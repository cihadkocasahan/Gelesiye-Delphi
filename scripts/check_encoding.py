#!/usr/bin/env python3
"""
Gelesiye Project - Encoding & Mojibake Auditor
Checks UTF-8 BOM compliance, mojibake, double-mojibake and DFM byte escapes.

Usage:
    python scripts/check_encoding.py          # Audit only (exit 1 if issues found)
    python scripts/check_encoding.py --fix    # Auto-fix missing / duplicate BOMs
"""

import os
import sys
import re
import argparse

if hasattr(sys.stdout, 'reconfigure'):
    try:
        sys.stdout.reconfigure(encoding='utf-8', errors='replace')
    except Exception:
        pass

REPO_ROOT    = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
EXCLUDE_DIRS = {".git", "bin", "dcu", "__history", "__recovery", ".gemini"}

DELPHI_BOM_EXTS = {".pas", ".dpr"}
TEXT_AUDIT_EXTS = {".pas", ".dfm", ".dpr", ".sql", ".md", ".json", ".bat"}

# Kendi scriptimizi denetim dışı bırak (false-positive önleme)
SELF_EXCLUDE = {"check_encoding.py"}

# ── Birincil (tek-geçiş) mojibake kalıpları ──────────────────────────────────
MOJIBAKE_PATTERNS = [
    ("Ã¼",  "ü"),
    ("Ã¶",  "ö"),
    ("ÄŸ",  "ğ"),
    ("ÅŸ",  "ş"),
    ("Ä±",  "ı"),
    ("Ã§",  "ç"),
    ("Ä°",  "İ"),
    ("Ã‡",  "Ç"),
    ("Ã–",  "Ö"),
    ("Ãœ",  "Ü"),
    ("Åž",  "Ş"),
    ("Äž",  "Ğ"),
    ("â‚º", "₺"),
    ("âš",  "⚠️"),
    ("ï¿½", "[Replacement char \ufffd]"),
]

# ── Çift mojibake kalıpları ───────────────────────────────────────────────────
# UTF-8 → Latin-1 → UTF-8 gibi iki kez yanlış encode/decode sonucu oluşur.
DOUBLE_MOJIBAKE_PATTERNS = [
    ("Ã\x83Â¼",   "ü  (double-mojibake)"),
    ("Ã\x83â€™",  "' (double-mojibake)"),
    ("Ã\x83Â¶",   "ö  (double-mojibake)"),
    ("Ã\x83Å¸",   "ş  (double-mojibake)"),
    ("Ã\x83Â±",   "ı  (double-mojibake)"),
    ("Ã\x83Â§",   "ç  (double-mojibake)"),
    ("Ã\x82Â°",   "İ  (double-mojibake)"),
    ("Ã\x83\x9f", "ğ  (double-mojibake)"),
]

# ── DFM çift-bayt escape kalıbı ──────────────────────────────────────────────
# GERÇEK sorun: UTF-8 2-byte lead (0xC2=194, 0xC3=195) + continuation (128-191)
# Örn: #195#188 = 0xC3 0xBC = UTF-8 encoded 'ü' (YANLIŞ — DFM'de #252 olmalı)
# #231#305 (çı) gibi geçerli Latin/Turkish code point çiftleri hariç tutulur.
DFM_DOUBLE_BYTE_RE = re.compile(r"#(194|195)#(1[2-9]\d|1[0-8]\d|[8-9]\d)")

# ── Genel double-encode regex ─────────────────────────────────────────────────
DOUBLE_ENCODE_RE = re.compile(r"Ã.{0,2}Ã")


def get_candidate_files():
    candidates = []
    for root, dirs, files in os.walk(REPO_ROOT):
        dirs[:] = [d for d in dirs if d not in EXCLUDE_DIRS]
        for f in files:
            if f in SELF_EXCLUDE:
                continue
            ext = os.path.splitext(f)[1].lower()
            if ext in TEXT_AUDIT_EXTS:
                candidates.append(os.path.join(root, f))
    return sorted(candidates)


def audit_file(filepath, fix=False):
    issues = []
    raw = open(filepath, "rb").read()
    ext = os.path.splitext(filepath)[1].lower()

    has_bom        = raw.startswith(b"\xef\xbb\xbf")
    has_double_bom = raw.startswith(b"\xef\xbb\xbf\xef\xbb\xbf")

    # ── 1. BOM kontrolü ──────────────────────────────────────────────────────
    if ext in DELPHI_BOM_EXTS:
        if has_double_bom:
            issues.append(("DOUBLE_BOM", "Çift UTF-8 BOM → E2029 derleyici hatası"))
            if fix:
                while raw.startswith(b"\xef\xbb\xbf"):
                    raw = raw[3:]
                raw = b"\xef\xbb\xbf" + raw
                open(filepath, "wb").write(raw)
                issues.append(("FIXED", "Çift BOM temizlendi, tek BOM yazıldı"))
        elif not has_bom:
            issues.append(("MISSING_BOM", "UTF-8 BOM eksik → Türkçe karakter bozulması"))
            if fix:
                open(filepath, "wb").write(b"\xef\xbb\xbf" + raw)
                issues.append(("FIXED", "UTF-8 BOM eklendi"))
                has_bom = True

    # ── 2. Metin decode ──────────────────────────────────────────────────────
    content = raw[3:] if has_bom else raw
    try:
        text = content.decode("utf-8")
    except UnicodeDecodeError as e:
        issues.append(("ENCODING_ERROR", f"UTF-8 decode başarısız: {e}"))
        return issues

    # ── 3. Birincil mojibake ─────────────────────────────────────────────────
    for seq, expected in MOJIBAKE_PATTERNS:
        count = text.count(seq)
        if count > 0:
            issues.append(("MOJIBAKE",
                f"{count}x '{seq}' bulundu → bozulmuş '{expected}'"))

    # ── 4. Çift mojibake (double-encode) ─────────────────────────────────────
    for seq, label in DOUBLE_MOJIBAKE_PATTERNS:
        count = text.count(seq)
        if count > 0:
            issues.append(("DOUBLE_MOJIBAKE",
                f"{count}x çift-encode dizisi → '{label}'"))

    dbl_hits = DOUBLE_ENCODE_RE.findall(text)
    if dbl_hits:
        issues.append(("DOUBLE_ENCODE_SUSPECT",
            f"Olası çift-encode kalıbı: {set(dbl_hits[:5])}"))

    # ── 5. DFM çift-bayt escape ──────────────────────────────────────────────
    if ext == ".dfm":
        escapes = DFM_DOUBLE_BYTE_RE.findall(text)
        if escapes:
            issues.append(("DFM_BYTE_ESCAPE",
                f"Ham çift-bayt escape: {set(escapes[:5])} → VCL'de mojibake"))

    return issues


def main():
    parser = argparse.ArgumentParser(
        description="Gelesiye encoding & mojibake denetleyicisi")
    parser.add_argument("--fix", action="store_true",
        help="Eksik/çift BOM sorunlarını otomatik düzelt")
    args = parser.parse_args()

    files = get_candidate_files()
    print(f"Checking {len(files)} files across repository...")
    if args.fix:
        print("Mode: --fix enabled (auto-repairing BOM issues)\n")
    else:
        print("Mode: Audit only (use --fix to automatically repair BOM issues)\n")

    fixed_count   = 0
    unfixed_count = 0

    for fp in files:
        rel = os.path.relpath(fp, REPO_ROOT)
        issues = audit_file(fp, fix=args.fix)

        for itype, imsg in issues:
            if itype == "FIXED":
                fixed_count += 1
                print(f"  [FIXED]   {rel}: {imsg}")
            elif args.fix and itype in ("MISSING_BOM", "DOUBLE_BOM"):
                print(f"  [AUTO-FIX] {rel} [{itype}]: {imsg}")
            else:
                unfixed_count += 1
                sev = "ERROR" if itype in (
                    "DOUBLE_BOM", "MISSING_BOM", "ENCODING_ERROR",
                    "MOJIBAKE", "DOUBLE_MOJIBAKE", "DFM_BYTE_ESCAPE"
                ) else "WARNING"
                print(f"  [{sev}] {rel} [{itype}]: {imsg}")

    print("\n" + "=" * 70)
    if unfixed_count == 0:
        msg = f"SUCCESS: All {len(files)} files are clean!"
        if fixed_count:
            msg += f" ({fixed_count} BOM issues were automatically repaired)"
        print(msg)
        sys.exit(0)
    else:
        print(f"FAILED: Found {unfixed_count} issue(s) in {len(files)} files.")
        if not args.fix:
            print("Run with '--fix':  python scripts/check_encoding.py --fix")
        sys.exit(1)


if __name__ == "__main__":
    main()
