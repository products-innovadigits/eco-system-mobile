"""Recorded raw on-device SLM outputs — dev-only spike component (T009d).

The full golden-set device run (T009b/T009c) has not been executed yet, so
only one raw output is currently recorded: the documented failure case from
`deterministic_grounding_spike_execution_plan.md` §0, observed across three
identical greedy (topK=1) runs of the current Qwen2.5 1.5B build on question
G01 ("مشاريع عالية الخطورة").

Add more entries here (id -> dict) as real device runs are captured in
`result_recording_template.md`; the runner treats a missing id as
"raw SLM output not available" rather than fabricating one.
"""

from __future__ import annotations

RAW_SLM_OUTPUTS: dict[str, dict] = {
    "G01": {
        "raw_text": (
            '{"filters":[{"table":"","column":"PeriortyLevelId","value":"الهامة"}],'
            '"relationships":[],"confidence":1.0}'
        ),
        "parsed": {
            "filters": [{"table": "", "column": "PeriortyLevelId", "value": "الهامة"}],
            "relationships": [],
            "confidence": 1.0,
        },
        "source": "deterministic_grounding_spike_execution_plan.md §0 (3x identical greedy on-device runs)",
    },
}


def get_raw_output(question_id: str) -> dict | None:
    return RAW_SLM_OUTPUTS.get(question_id)
