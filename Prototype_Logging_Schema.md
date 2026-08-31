# Echo Grid — Prototype Logging Schema

## 1. Mục tiêu

Tài liệu này định nghĩa cấu trúc JSON schema ghi nhận dữ liệu đo lường (telemetry) của phiên chơi thử nghiệm trong giai đoạn **Phase 0 — Validation Spike**. Hệ thống ghi log được tích hợp trực tiếp vào app để tự động ghi lại hành vi của người chơi trong suốt quá trình thử nghiệm.

---

## 2. JSON Schema Definition

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "EchoGrid_SessionLog",
  "type": "object",
  "required": [
    "sessionId",
    "participantId",
    "deviceModel",
    "hasPhoneCase",
    "conditionType",
    "startTime",
    "endTime",
    "durationSeconds",
    "totalMoves",
    "invalidMoves",
    "oscillationCount",
    "solved",
    "finalResonanceScore",
    "events",
    "postTestInterview"
  ],
  "properties": {
    "sessionId": {
      "type": "string",
      "format": "uuid",
      "description": "Unique identifier for the test session"
    },
    "participantId": {
      "type": "string",
      "description": "Moderator assigned participant code (e.g., P01, P02)"
    },
    "deviceModel": {
      "type": "string",
      "description": "iOS Device model identifier (e.g., iPhone 15 Pro, iPhone SE 3)"
    },
    "hasPhoneCase": {
      "type": "boolean",
      "description": "Whether the participant tested with a phone case attached"
    },
    "conditionType": {
      "type": "string",
      "enum": ["hapticOnly", "fullSensory"],
      "description": "Experimental condition branch"
    },
    "startTime": {
      "type": "string",
      "format": "date-time"
    },
    "endTime": {
      "type": "string",
      "format": "date-time"
    },
    "durationSeconds": {
      "type": "number",
      "description": "Total elapsed seconds from first touch to completion or abort"
    },
    "totalMoves": {
      "type": "integer",
      "minimum": 0,
      "description": "Total number of completed node moves"
    },
    "invalidMoves": {
      "type": "integer",
      "minimum": 0,
      "description": "Number of moves dropped on an already occupied or invalid cell"
    },
    "oscillationCount": {
      "type": "integer",
      "minimum": 0,
      "description": "Number of back-and-forth moves between neighboring cells"
    },
    "trialAndErrorRatio": {
      "type": "number",
      "description": "Ratio of totalMoves / optimalMoves (optimal is 6 for prototype opening)"
    },
    "solved": {
      "type": "boolean",
      "description": "Whether the puzzle reached 1.0 resonance within the timebox"
    },
    "finalResonanceScore": {
      "type": "number",
      "minimum": 0.0,
      "maximum": 1.0
    },
    "events": {
      "type": "array",
      "items": {
        "$ref": "#/$defs/SessionEvent"
      },
      "description": "Chronological timeline of all interactions during the session"
    },
    "postTestInterview": {
      "$ref": "#/$defs/PostTestInterview"
    }
  },
  "$defs": {
    "SessionEvent": {
      "type": "object",
      "required": ["timestampOffsetSec", "type"],
      "properties": {
        "timestampOffsetSec": {
          "type": "number",
          "description": "Seconds from session start"
        },
        "type": {
          "type": "string",
          "enum": ["session_start", "drag_start", "drag_drop", "invalid_drop", "score_update", "solved", "reset", "session_abort"]
        },
        "nodeId": {
          "type": "string"
        },
        "fromPosition": {
          "type": "object",
          "properties": {
            "row": {"type": "integer"},
            "col": {"type": "integer"}
          }
        },
        "toPosition": {
          "type": "object",
          "properties": {
            "row": {"type": "integer"},
            "col": {"type": "integer"}
          }
        },
        "resonanceScore": {
          "type": "number"
        },
        "hapticFeedbackTriggered": {
          "type": "string",
          "enum": ["none", "far", "progress", "solved", "snap"]
        }
      }
    },
    "PostTestInterview": {
      "type": "object",
      "properties": {
        "ruleDescribedByParticipant": {
          "type": "string",
          "description": "Participant's verbatim explanation of the hidden rule"
        },
        "ruleCorrectness": {
          "type": "string",
          "enum": ["correct", "partially_correct", "incorrect"]
        },
        "mostHelpfulFeedback": {
          "type": "string",
          "enum": ["haptic", "visual", "audio", "none"]
        },
        "confidenceScore": {
          "type": "integer",
          "minimum": 1,
          "maximum": 5
        },
        "hadAhaMoment": {
          "type": "boolean"
        },
        "notes": {
          "type": "string"
        }
      }
    }
  }
}
```

---

## 3. Ví dụ Output JSON mẫu

```json
{
  "sessionId": "9B2F53E2-3CD2-4F54-B831-5CD3A8DE0159",
  "participantId": "P-04",
  "deviceModel": "iPhone 15 Pro",
  "hasPhoneCase": true,
  "conditionType": "hapticOnly",
  "startTime": "2026-08-31T14:15:00Z",
  "endTime": "2026-08-31T14:20:12Z",
  "durationSeconds": 312.4,
  "totalMoves": 9,
  "invalidMoves": 1,
  "oscillationCount": 2,
  "trialAndErrorRatio": 1.5,
  "solved": true,
  "finalResonanceScore": 1.0,
  "events": [
    {
      "timestampOffsetSec": 0.0,
      "type": "session_start",
      "resonanceScore": 0.2
    },
    {
      "timestampOffsetSec": 12.3,
      "type": "drag_drop",
      "nodeId": "M1",
      "fromPosition": { "row": 1, "col": 3 },
      "toPosition": { "row": 0, "col": 4 },
      "resonanceScore": 0.55,
      "hapticFeedbackTriggered": "progress"
    },
    {
      "timestampOffsetSec": 312.4,
      "type": "solved",
      "resonanceScore": 1.0,
      "hapticFeedbackTriggered": "solved"
    }
  ],
  "postTestInterview": {
    "ruleDescribedByParticipant": "Khi đặt các chấm đối xứng nhau qua hàng dọc ở giữa thì điện thoại rung êm và mạnh dần.",
    "ruleCorrectness": "correct",
    "mostHelpfulFeedback": "haptic",
    "confidenceScore": 5,
    "hadAhaMoment": true,
    "notes": "Người chơi thử 2 nước đầu hơi do dự, sau đó nhận ra nhịp rung và giải rất dứt khoát."
  }
}
```
