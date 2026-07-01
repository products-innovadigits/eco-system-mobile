"""Business vocabulary lexicon — dev-only spike component (T009d).

Pure data + tiny lookup helpers. This is the "anti-hardcoding answer" the
spike scope calls for: concept -> synonyms -> schema target, editable by a
domain expert without touching matching code.

All Arabic terms below are pre-normalized the same way `normalizer.py`
normalizes question text (tashkeel stripped, alef/hamza/ya/ta-marbuta
collapsed) so substring matching against a normalized question is exact.
"""

from __future__ import annotations

from dataclasses import dataclass, field


@dataclass(frozen=True)
class Concept:
    id: str
    table: str | None          # target lookup/related table, or None (no FK)
    column: str | None         # FK column on Projects, or None
    value_prefix: str | None   # canonical lookup-value prefix, e.g. "مخاطر"
    strong_terms: tuple[str, ...]      # unambiguous synonyms
    ambiguous_terms: tuple[str, ...] = field(default_factory=tuple)


# Level words shared by risk / priority (both lookup tables use the same
# "<label> <level>" naming convention in this schema).
LEVEL_WORDS = {
    "high": ("عاليه", "عالي", "high"),
    "medium": ("متوسطه", "متوسط", "medium", "moderate"),
    "low": ("منخفضه", "منخفض", "low"),
}

CONCEPTS: tuple[Concept, ...] = (
    Concept(
        id="risk",
        table="RiskLevels",
        column="RiskLevelId",
        value_prefix="مخاطر",
        strong_terms=("خطوره", "مخاطر", "خطر", "risk", "severity", "hazard"),
    ),
    Concept(
        id="priority",
        table="PeriortyLevels",
        column="PeriortyLevelId",
        value_prefix="اولويه",
        strong_terms=("اولويه", "الاولويه", "priority", "importance"),
        # "important"-style words are deliberately NOT strong terms: they are
        # genuinely ambiguous between priority and (loosely) risk, and the
        # ranker must return needs_clarification rather than guess.
        ambiguous_terms=("هام", "هامه", "الهامه", "مهم", "مهمه", "المهمه", "important", "critical"),
    ),
    Concept(
        id="department",
        table="DepartmentLookups",
        column="ImplementorDepartmentId",
        value_prefix=None,
        strong_terms=("اداره", "قسم", "department", "dept"),
    ),
    Concept(
        id="manager",
        table="AspNetUsers",
        column="ManagerId",
        value_prefix=None,
        # "manag" is a stem covering manager/managed/managing/management.
        strong_terms=("مدير", "المسؤول", "مسؤول", "responsible", "manag"),
    ),
    Concept(
        id="delayed",
        table=None,
        column="EndDate",
        value_prefix=None,
        strong_terms=("متاخر", "تاخر", "overdue", "late", "delayed"),
    ),
    Concept(
        id="lifecycle",
        table="ProjectLifeCycleModels",
        column="LifeCycleId",
        value_prefix=None,
        strong_terms=("مرحله", "دوره حياه", "lifecycle", "life cycle"),
    ),
    Concept(
        id="category",
        table="ProjectCategories",
        column="ProjectCategoryId",
        value_prefix=None,
        strong_terms=("فئه", "تصنيف", "category"),
    ),
    Concept(
        id="budget",
        table=None,
        column="Budget",
        value_prefix=None,
        # "ميزاني" is the shared stem across ميزانية / ميزانيتها / ميزانيات
        # (ta-marbuta -> ta when a possessive suffix attaches), so match the
        # stem rather than one fixed suffixed form.
        strong_terms=("ميزاني", "budget"),
    ),
    Concept(
        id="dates",
        table=None,
        column="EndDate",
        value_prefix=None,
        strong_terms=(
            "هذا الشهر", "الشهر القادم", "due soon", "ending soon",
            "starting next month", "this month", "next month",
        ),
    ),
)

CONCEPTS_BY_ID = {c.id: c for c in CONCEPTS}

# Words describing a status/lifecycle concept that this schema does NOT have
# a status column for. Per m0_golden_questions.md, these must clarify /
# unsupported, never a confident guess.
STATUS_AMBIGUOUS_TERMS = (
    "مكتمله", "المكتمله", "completed", "active", "نشطه", "معلقه", "on hold", "hold",
)

# Direct out-of-scope signals (no DB write, no schema introspection, no
# unrelated small talk, no sensitive data).
UNSUPPORTED_TERMS = (
    "weather", "قصيده", "poem", "delete", "احذف", "اعمده", "أعمدة",
    "columns of", "salary", "راتب", "salaries",
)

# Phrasing that means "group by <concept>" (summarize/aggregate), as opposed
# to naming one specific value of that concept. No value is invented for
# these; only the relationship/table is surfaced.
GROUP_BY_MARKERS = ("حسب", "by department", "by manager", "by category", "by lifecycle", "group by")

# Phrasing that references a specific-but-unstated value ("a certain
# manager", "this project") — the value is implied but absent, so the
# ranker must clarify rather than guess which one.
VAGUE_REFERENCE_TERMS = ("معين", "محدد", "هذا المشروع", "this project", "given", "certain", "specific")

# Vague size/scale wording with no lexicon concept behind it (could mean
# budget, output count, team size, ...). Not in CONCEPTS because it maps to
# no single schema target — the correct behavior is to clarify, not guess.
SIZE_AMBIGUOUS_TERMS = ("كبيره", "كبير", "صغيره", "large", "big")
