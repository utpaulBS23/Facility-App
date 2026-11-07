Facility 37

1. [Admin setup](#setup)

Basics

1. [What changed](#changes)
2. [Overview](#overview)
3. [Rules for every call](#rules)
4. [Status codes & retries](#status)

Required APIs

1. [POSTQR validation](#qr)
2. [GETSettings pull](#settings)
3. [POSTDoor event](#door-event)
4. [POSTAlert](#alert)
5. [POSTSensor](#sensor)

Optional APIs

1. [POSTSnapshot upload](#snapshot)

Delivery

1. [Facility app (no backend call)](#facility-app)
2. [Testing with the dummy](#testing)
3. [Done checklist](#done)

Bhumijo facility node · backend contract

# Facility Node Backend API

The APIs the admin backend provides for the Raspberry Pi in each facility, as built on the backend branch `feature/facility-node-api`, and what to enter in the admin panel for facility 37. The Pi calls the backend; the backend never calls the Pi.

Direction

Pi → backend, HTTPS

Auth (pushes, pull)

Authorization: Bearer \<node key>

Auth (QR check)

Device-Auth-Code: \<code>

Body

JSON, UTF-8

Time

ISO 8601 UTC, "…Z"

Timeout

10 s (QR: 5 s)

## Admin setup for facility 37

Enter these in the admin panel (partner → facility 37), in this order. The IPs and MACs are what the Pi sees on the facility network today (5 November, from its ARP table). The device ids are given by the backend (`BHU-…`, automatic); write them down, the Pi needs the two door ids.

### 1. Device List: add six devices

| Device | Name | Model | IP | Port | MAC |
| --- | --- | --- | --- | --- | --- |
| Facility node | Facility Node | Raspberry Pi 5 | `192.168.10.104` | 5454 | `2c:cf:67:01:a7:ea` |
| Male door | Gents Toilet | QR scanner | `192.168.10.101` | 80 | `00:88:22:09:87:58` |
| Female door | Ladies Toilet | QR scanner | `192.168.10.102` | 80 | *unknown: scanner offline* |
| Relay board | Door Relay | KC868 | `192.168.10.174` | 80 | `2c:bc:bb:bf:70:a3` |
| Camera | Main Camera | IP camera (RTSP) | `192.168.10.149` | 554 | `90:6a:94:66:7c:9d` |
| Air sensor | Odour Sensor | ESP32-S3 air board | `192.168.10.105` | 80 | `64:e8:33:73:de:ac` |

- **The Pi's MAC** is its cable (eth0) MAC, the one it sends in the settings pull. On WiFi it appears as `…:a7:eb`; that is expected.
- **Each door is its QR scanner.** Each door has its own scanner (own IP and MAC); the relay board serves both doors, so it can't stand for one.
- **Female scanner MAC:** fill in later. Power the scanner on, then on the Pi run `facility macs`, or read the label.
- The Device List's **Auth Code** for this facility is the `Device-Auth-Code` for `/qr/validate` and the Facility app's code. Set one.

### 2. Gates: link each door to its service

Facility node → Gates → add, once per door. The service decides the price and gender, so its `section` must be `male` or `female`.

| Gate (device) | Service | Section |
| --- | --- | --- |
| Gents Toilet (.101) | the facility's toilet service for men | `male` |
| Ladies Toilet (.102) | the facility's toilet service for women | `female` |

```
POST /api/backend/partners/{partner}/facility-node/gates   (once per door)
{ "device_id": <Gents Toilet device row id>, "facility_service_id": <male service id> }
```

### 3. Node: register the Pi and get its key

```
POST /api/backend/partners/{partner}/facility-node/nodes
{
  "device_id": <Facility Node device row id>,
  "camera_doors": { "main": ["<male door BHU id>", "<female door BHU id>"] },
  "lan_ip": "192.168.10.104"
}
```

**Copy the `api_key` (`fnk_…`) straight away.** It is shown once. Lost it? Rotate the key to get a new one. Give it to the field team privately, never in a chat.

- `camera_doors`: one camera, named `main` on the Pi, pictures both doors.
- `lan_ip`: the Facility app finds the Pi by it. The router needs a DHCP reservation so the Pi keeps `.104`.

### 4. What the Pi then needs

The field team enters these with `facility config` on the Pi. Secrets are typed there, not sent in chat.

| Pi setting | Value | From |
| --- | --- | --- |
| FACILITY_ID | `37` Done | the facility's id |
| ADMIN_URL | the deployed API base, ending in `/api` | backend team |
| ADMIN_KEY | the node key `fnk_…` | step 3 |
| DEVICE_AUTH_CODE | the facility's Auth Code | step 1 |
| DOOR_MALE_ID | Gents Toilet's `BHU-…` | step 1 |
| DOOR_FEMALE_ID | Ladies Toilet's `BHU-…` | step 1 |
| Paths and `QR_API_*` | as in `.env.example` (paths below; `QR_API_ORDER=api_only` only once the backend answers) | repository |

Afterwards `facility doctor` on the Pi should show the settings pull answering 200, and `/health` each door's name and price.

- [ ] Six devices in the Device List (female scanner MAC to follow)
- [ ] Auth Code set for facility 37
- [ ] Two gates: Gents Toilet → male service, Ladies Toilet → female service
- [ ] Node created with `camera_doors` and `lan_ip`; `fnk_…` key copied
- [ ] Door ids, node key, Auth Code and the API URL handed to the field team
- [ ] Backend deployed; `facility doctor` on the Pi is green

## Changed in this version (5 November)

- **Real paths:** the backend serves the Pi under `/api/gateway/facility-node/`: `config` (settings pull), `sensor`, `door-event`, `alert`, `snapshot`. `/api/qr/validate` is unchanged. These are now the Pi's defaults.
- **One node key per facility** (`fnk_…`, from Nodes in the admin panel); a body whose `facility` isn't the key's gets 403. `facility` is the facility's numeric id, e.g. `37`.
- **Facility app:** sends `attendant_id` (the attendant's backend user id). Personal use needs both `attendant` and `attendant_id`.
- **Sensor:** each LAN device in `devices` adds `reachable`, so device-offline alerts can work.
- **QR:** 401 `invalid_device_code` and 404 `unknown_door` are the Pi's setup: denied as `setup_error`, scanner shows "Door error, please call the attendant".
- **Retries:** 404 / 405 mean the endpoint is missing: the Pi keeps everything and waits, nothing is dropped.

### 3 November

- **Doors are named by device id**, like `BHU-001`, everywhere: `door` in `/qr/validate`, door events and alerts, and the keys of `doors` and the values of `cameraDoors` in the settings pull. The Pi links each id to its wiring in `.env` (`DOOR_MALE_ID`, `DOOR_FEMALE_ID`).
- **Door events and alerts:** `section` is renamed `door` (the device id), and `source` is gone: `type` says what happened.
- **Settings pull adds `doors`**: each door's name and price. `tokens` is no longer needed.
- **Prices:** a charged QR `entry` records the door's `price`; a Facility-app cash sale with no amount takes the price, and a different amount is flagged `price_mismatch`.
- **Personal use** from the Facility app always carries the gate (`door`), `purpose` and `attendant` (now required).
- **Device MACs:** the sensor push adds `devices` (each LAN device's IP and MAC, and whether it matches); new alert `device_mismatch` when another device takes one's IP.

### Earlier, since 2 October

- **QR validation is now required.** Customers scan a QR from the Jabo Khotai app; the Pi asks `/qr/validate` with the facility's `Device-Auth-Code`. The backend runs its `/user/accesses` logic inside and answers `200 {"message": "Service unlocked"}` to open. No internet means no QR entry.
- **Charge each scan once.** Every QR call carries a `scan_id` (also the `Idempotency-Key` header). Refund when a `relay_failed` door event arrives.
- **Token pull is now the settings pull**: `authCode` and the new `cameraDoors`. The request adds `mac`, the Pi's MAC address, to match the Device List. It may be renamed, e.g. `/facility/config`.
- **Door event**: new type `relay_failed`; denials add `offline`, `api_reason`, `scan_id`; attendant opens add `use`, `payment`, `amount`, `purpose`, `attendant`.
- **Several cameras**: alerts and snapshots name the `camera`; the sensor push adds `cameras`; `propped_open` carries a snapshot on every repeat.
- **Sensor**: adds `tvoc_score` (0–100) and `tvoc_level`; `nh3_ppm` and `h2s_ppm` are always present (`null` when not fitted).

## Overview

Each facility has one Pi controlling two doors (gates), each known to the backend by its device id, e.g. `BHU-001` (male) and `BHU-002` (female). Customers enter by scanning a QR from the Jabo Khotai app, which the backend checks and charges live. Attendants open doors with the Facility app, which talks to the Pi over the facility WiFi and works offline. Everything the Pi records goes into a queue on its SD card first, then to these APIs, oldest first after an outage.

| API | Default path | Called | Status |
| --- | --- | --- | --- |
| QR validation | `POST /qr/validate` | Each customer scan | Required |
| Settings pull | `GET /gateway/facility-node/config` | Every 5 min | Required |
| Door event | `POST /gateway/facility-node/door-event` | Each entry, exit, denial, close | Required |
| Alert | `POST /gateway/facility-node/alert` | Each anomaly | Required |
| Sensor | `POST /gateway/facility-node/sensor` | Every 60 s | Required |
| Snapshot upload | `POST /gateway/facility-node/snapshot` | With each door alert | Optional |

Paths are relative to the Pi's `ADMIN_URL`, the backend's base ending in `/api`. They are the Pi's defaults; each can still be changed in its `.env`.

| Opens with | Needs internet? | When the internet is down |
| --- | --- | --- |
| Jabo Khotai QR | **Yes** (backend checks and charges) | Refused; scanner shows "No internet, please try again" |
| Facility app | No (phone on the facility WiFi) | Opens; the event is sent later |
| Exit button | No (hardware) | Opens, even with the Pi off |

## Rules for every call

### Authentication

Pushes and the settings pull carry `Authorization: Bearer <node key>`: the `fnk_…` key from Nodes, one per facility, stored hashed and rotatable on its own. The backend checks that the key belongs to the `facility` in the body or query (401 bad key, 403 other facility).

The QR check carries `Device-Auth-Code: <code>` instead: the facility's Auth Code from the admin panel's Device List, one per facility. The admin key is not sent on that call.

### Idempotency: every pushed item has an `id`

**The Pi can send the same event twice.** If your server saves an event but the reply is lost (network drop, timeout), the Pi retries. Every pushed item carries a UUID `id`, in the body and as the `Idempotency-Key` header, and the retry uses the **same** id. Store the id with a unique constraint. On a repeat, reply 200 and don't save it again.

### Timestamps

`ts` is when the event **happened** on the Pi, in UTC. After an outage, events can arrive minutes or days late, so sort and report by `ts`, never by arrival time.

### Volume

- Normal load per facility: 1 sensor push per minute, 1 settings pull per 5 minutes, one QR check per customer, plus door events and alerts as they happen.
- **After an outage, expect a burst.** One day offline is about 1,440 sensor readings plus the day's door events, sent back to back. Reply quickly, and don't rate-limit a facility catching up.
- Reply within 10 seconds (QR: 5 seconds), or the Pi treats the call as failed.

### Transport

HTTPS with a valid public certificate. The Pi verifies certificates, so a self-signed one fails. Ignore unknown extra fields rather than rejecting them: new optional fields may appear in later versions.

## Status codes & retries

For pushes, your status code decides what the Pi does with the item. Getting this wrong means lost data or endless retries.

| You reply | Meaning to the Pi | Pi does |
| --- | --- | --- |
| 2xx | Saved: `{"ok": true}`, or `{"ok": true, "duplicate": true}` for a repeated id | Removes it from the queue |
| 5xx, 408, 429 | Temporary problem | Keeps it, pauses, retries in about 15 s |
| 401, 403 | Key problem, not the data | Keeps it and retries; nothing is lost while you fix the key |
| 404, 405 | Endpoint missing (not deployed, or wrong path) | Keeps everything and pauses; nothing is dropped |
| Other 4xx (400, 422…) | This item is invalid | Retries 5 times, then drops *that item* and logs it, so it can't block the queue |

Use 422 for a well-formed request with bad content (missing field, unknown `type`). Don't return 500 for bad input: the Pi would retry it forever. The QR check has its own table below.

## QR validation

POST/qr/validateRequiredChanged

**Called** for each customer scan · **Pi settings** `QR_API_URL`, `QR_API_*`, `DEVICE_AUTH_CODE`

The customer shows the QR from the Jabo Khotai app (their `device_access_token`). The Pi picks the door from the scanner's IP and asks this endpoint. It opens the gate only on your "Service unlocked".

### Request

```
POST /api/qr/validate
Device-Auth-Code: <the facility's Auth Code>
Idempotency-Key: 6f1c2b7e-…
{
  "token": "<customer QR token>",
  "facility": "37",
  "door": "BHU-001",
  "scan_id": "6f1c2b7e-…"
}
```

| Field | Type | Notes |
| --- | --- | --- |
| token | string | Exactly what the scanner read: the customer's `device_access_token`. |
| facility | string | The facility's id (the Pi's `FACILITY_ID`), e.g. `"37"`. |
| door Changed | string | The gate's device id, e.g. `BHU-001`. Find the gate's service, gender and price by it. |
| scan_id | uuid | A new random id for every scan; also the `Idempotency-Key` header. **Not a credential** (that is `Device-Auth-Code`): it lets you charge a scan once even if the Pi has to ask twice, and a `relay_failed` event names it for the refund. |

### What the backend does inside

1. Check `Device-Auth-Code` belongs to `facility`; otherwise 401.
2. Find the gate with device id `door` in this facility: its `service_id`, `gender` and price. These stay in the backend; the Pi does not send or keep them.
3. Run the `/user/accesses` logic with `{service_id, gender, device_access_token: token}`: check the balance and charge.
4. **Charge each `scan_id` once.** Asked again with the same `scan_id` (the Pi's reply got lost), answer the first result without charging again.
5. Answer the Pi as below.

### Response

```
200 — open the gate
{ "message": "Service unlocked" }

402 / 403 / … — keep it shut
{ "message": "insufficient_balance" }
```

| Your reply | Pi does | Scanner shows |
| --- | --- | --- |
| 200 "Service unlocked" | Opens the gate for 5 s; door event `entry` with `scan_id` and `price` | "Please Enter the facility" |
| 402 insufficient_balance | Keeps it shut; logs `message` as `api_reason` | "Insufficient balance, please top up" |
| 403 invalid_token, user_blocked 400 recent_usage, 422 | Keeps it shut; logs `message` as `api_reason` | "Access denied" |
| 200, any other message | Keeps it shut | "Access denied" |
| 401 invalid_device_code 404 unknown_door | Keeps it shut (`reason: setup_error`); logs an error: the Pi's Auth Code or door id is wrong, not the customer's code | "Door error, please call the attendant" |
| 5xx (incl. 503 processing), timeout > 5 s, network error | Keeps it shut (`reason: offline`) | "No internet, please try again" |

**The success text must be exactly `Service unlocked`.** Case and outer spaces don't matter, but `"Service unlocked."` with a full stop would keep the gate shut. Send every refusal as a 4xx with the reason in `message`.

**Refunds.** If the relay fails after "Service unlocked", the customer paid but did not get in. The Pi sends a `relay_failed` door event with the same `scan_id`: refund it. **Also refund straight away on a `denied` event with `reason: offline` and a `scan_id`**: the Pi gave up after 5 s, so if the backend charged that scan late, nobody got in. Today the backend only refunds such scans after 30 minutes.

## Settings pull

GET/gateway/facility-node/config?facility=37&mac=2c:cf:67:01:a7:eaRequiredChanged

**Called** every 5 minutes and at start-up · **Pi setting** `TOKENS_PATH`

Settings office staff change in the admin panel. The Pi saves them, so they survive a reboot during an outage. A failed pull keeps the previous settings.

| Query parameter | Type | Notes |
| --- | --- | --- |
| facility | string | The Pi's `FACILITY_ID`; must be the node key's facility (else 403). |
| mac New | string? | The Pi's MAC address, lower case with colons, e.g. `2c:cf:67:01:a7:ea`. The backend compares it with the node's MAC in the Device List; a different MAC is recorded and shown, and the pull is still served. It is the board's eth0 MAC (the same on cable or WiFi) unless the Pi's `DEVICE_MAC` overrides it. Left out when the Pi can't read one. |

```
{
  "facilityId": "37",
  "authCode": "8f2k-Qx91-zt",
  "doors": {
    "BHU-001": { "name": "Gents Toilet",  "price": 10 },
    "BHU-002": { "name": "Ladies Toilet", "price": 10 }
  },
  "cameraDoors": { "main": ["BHU-001", "BHU-002"] }
}
```

| Field | Type | Notes |
| --- | --- | --- |
| facilityId | string | Must equal the requested `facility`. A reply for another facility is ignored. |
| authCode | string? | The facility's Auth Code, the same code as `Device-Auth-Code`. Left out when none is set (the Pi keeps its last one). The Facility app sends it to unlock. Rotate it by changing it here. The Pi stores only its hash. Until this arrives, the Pi uses the code set in its `.env`. |
| doors New | object? | Each gate's `name` and `price` (number, ≥ 0), keyed by device id. The Pi keeps it across reboots; missing = keep the last one. An id the Pi doesn't have is ignored. Used in the Facility app's buttons, cash sales, the scanner screen and the price recorded on paid entries. Never decides whether a door opens. |
| cameraDoors | object? | Which camera pictures which door's alerts: camera name (`main` for a single camera) or camera IP → list of door device ids. One camera per door; one camera may cover both. A door left out gets no picture. Missing, `null` or `{}` = use the Pi's `.env`. Unknown cameras or doors: ignored and logged. Camera logins never come from the backend. |

## Door event

POST/gateway/facility-node/door-eventRequiredChanged

**Called** for every entry, attendant unlock, exit, denial and door close · **Pi setting** `DOOR_EVENT_PATH`

The access log. One record per event.

```
{
  "id": "b21e6c0e-5f0b-4d8e-9d39-2c51a0f4e7a2",
  "facility": "37",
  "door": "BHU-002",
  "type": "attendant",
  "use": "personal", "purpose": "cleaning",
  "attendant": "rahim", "attendant_id": 615,
  "ts": "2026-10-30T10:15:03Z"
}
```

| Field | Type | Notes |
| --- | --- | --- |
| id | uuid | Unique per event. Deduplicate on it. |
| facility | string | Facility ID. |
| door Changed | string | The gate's device id, e.g. `BHU-002` (was `section`). Until the Pi has the id set, its own door name (`male` / `female`). |
| type | string | What happened; see the table below. There is no `source` field any more. |
| scan_id | uuid? | The QR check's id, on `entry`, `denied` and `relay_failed` after a QR check. |
| price New | number? | The door's price (from `doors`) at that moment: on a charged `entry` and on cash sales. |
| price_mismatch New | true? | Cash sale whose `amount` differs from `price` (the door still opened). |
| reason | string? | QR denials only: `api_denied`, `offline`, `setup_error` (your 401 / `unknown_door`), `unknown`, `empty`. |
| api_reason | string? | Your `message` when you refused, e.g. `insufficient_balance`. |
| use, purpose, payment, amount, attendant, attendant_id | mixed? | Facility app opens: `use` = `customer` (with `payment: "cash"`, `amount`: the price when the attendant typed none, `attendant`?, `attendant_id`?) or `personal` (with `purpose`: `cleaning`, `bath`, `toilet`, `maintenance`, and both `attendant` (name) and `attendant_id` (backend user id), always present). Absent from an older app. |
| duration_s | integer? | Only on `door_closed`: seconds the door was open. |
| ts | string | When it happened (UTC). |

| type | Meaning |
| --- | --- |
| entry | Opened by QR. With `scan_id` + `price`: approved and charged by `/qr/validate` (Jabo Khotai). Without: a staff code made on the Pi |
| attendant | Opened by the Facility app (`use`, `purpose`, `attendant`, or the cash-sale fields) |
| exit | Exit button pressed (opens in hardware); no extra fields |
| denied | QR refused (has `reason`), or wrong Auth Code in the Facility app (no `reason`) |
| relay_failed | Paid but the door did not open: with `scan_id` (QR charge) **refund it**; with `payment: cash` **void the sale** |
| door_closed | Door shut again, with `duration_s` (needs the door sensor) |

## Alert

POST/gateway/facility-node/alertRequiredChanged

**Called** for each anomaly · **Pi setting** `ALERT_PATH`

Things a person should look at. Wire your notifications (SMS, push, dashboard alarm) to this endpoint.

```
{
  "id": "c9a04d51-2a7e-4f43-8c3b-61d1b9f0aa10",
  "facility": "37",
  "door": "BHU-002",
  "type": "anomaly",
  "subtype": "propped_open",
  "duration_s": 300,
  "repeat": false,
  "snapshot": "20261103T101500Z-main.jpg",
  "camera": "main",
  "ts": "2026-10-30T10:15:00Z"
}
```

| subtype | Fields | Handle as |
| --- | --- | --- |
| forced_open | `door`, `snapshot?`, `camera?` | New alarm: door opened with no QR, app or exit press |
| propped_open | `door`, `duration_s`, `repeat`, `snapshot?`, `camera?` | `repeat:false` = new alarm (open 5 min); `repeat:true` = update, every 3 min while still open, each with a new snapshot |
| propped_resolved | `door`, `duration_s` | All-clear for that door's propped alarm |
| odour_high | `duration_s`, `repeat`, `metrics`, `readings` | `repeat:false` = new "needs cleaning" alarm; `true` = update. Facility-wide, no `door` |
| odour_resolved | `duration_s`, `readings` | All-clear for the odour alarm |
| device_mismatch New | `device`, `ip`, `expected`, `seen`, `door` (scanners) | Security alarm: a device with the wrong MAC is on that IP (e.g. a laptop posing as the relay board). The Pi blocks it. Repeated at most every 10 min while it lasts |

| Field | Type | Notes |
| --- | --- | --- |
| door Changed | string? | The gate's device id (was `section`). Absent on odour alerts. |
| type | string | Always `anomaly`. |
| snapshot | string? | Image file name, `<time>-<camera>.jpg`. Present when that door's camera answered. Matches `name` in the snapshot upload, which arrives first. |
| camera New | string? | The camera that took it (the one linked to this door in `cameraDoors`). |
| metrics | string\[\] | Which limits were crossed: any of `tvoc`, `tvoc_score`, `aqi`, `nh3_ppm`, `h2s_ppm`. |
| readings | object | Current values of the monitored metrics, e.g. `{"tvoc": 1620, "tvoc_score": 53}`. |

## Sensor

POST/gateway/facility-node/sensorRequiredChanged

**Called** every 60 seconds · **Pi setting** `SENSOR_PATH`

Air quality, temperature and humidity, plus every camera's health. Store it as a time series for charts, cleaning reports and the Camera Status page.

```
{
  "id": "7f3c2a9e-0d4b-4c1e-b0a8-5e9f71c3d2b4",
  "facility": "37",
  "ts": "2026-10-30T10:15:00Z",
  "tvoc": 412, "tvoc_score": 31, "tvoc_level": "good",
  "eco2": 780, "aqi": 3,
  "temperature": 29.6, "humidity": 78.4,
  "nh3_ppm": null, "h2s_ppm": null,
  "camera":  { "reachable": true, "streaming": true, "frozen": false, "checked_at": "…" },
  "cameras": {
    "main": { "reachable": true, "streaming": true, "frozen": false, "checked_at": "…" }
  },
  "devices": {
    "relay":        { "ip": "192.168.10.174", "mac": "2c:bc:bb:bf:70:a3", "expected": ["2c:bc:bb:bf:70:a3"], "ok": true, "reachable": true },
    "scanner_male": { "ip": "192.168.10.101", "mac": "00:88:22:09:87:58", "expected": null, "ok": null, "reachable": true },
    "scanner_female": { "ip": "192.168.10.102", "mac": null, "expected": null, "ok": null, "reachable": false },
    "camera_main":  { "ip": "192.168.10.149", "mac": "90:6a:94:66:7c:9d", "expected": null, "ok": null, "reachable": true }
  }
}
```

| Field | Unit | Notes |
| --- | --- | --- |
| tvoc | ppb | Total volatile organic compounds (ENS160) |
| tvoc_score New | 0–100 | Worked out on the Pi from TVOC; 20 points per UBA level |
| tvoc_level New | text | `very_good`, `good`, `moderate`, `dangerous`, `very_dangerous` |
| eco2 | ppm | Equivalent CO₂ (ENS160) |
| aqi | 1–5 | UBA air-quality index: 1 excellent … 5 unhealthy |
| temperature | °C | AHT20 |
| humidity | % RH | AHT20 |
| nh3_ppm, h2s_ppm | ppm | Ammonia (MQ-135), hydrogen sulphide (MQ-136). Always present; `null` where no gas sensor is fitted |
| cameras New | object | Every camera by name: `reachable`, `streaming`, `frozen`, `checked_at`. `null` when the camera function is off |
| camera | object | The first camera again, for backends built before several cameras |
| devices New | object | Every LAN device the Pi talks to (relay board, scanners, cameras, sensor board): `ip`, the `mac` the Pi sees, the `expected` MACs set on the Pi, `ok` (`true`, `false` = blocked, `null` = no MAC set, not checked; `expected` is then `null` too, so accept nulls) and `reachable` New (`true` / `false`, checked just before each push; `null` before the first check). Shown in the Device List; drives the device-offline alerts |

**Any reading can be `null`**: a sensor warming up (ENS160 for about 3 min after boot), failed, or not fitted. Store `null` as "no data", never as 0.

## Snapshot upload

POST/gateway/facility-node/snapshotOptionalChanged

**Called** on `forced_open` and every `propped_open` · **Pi setting** `SNAPSHOT_UPLOAD_PATH`

A JPEG from the door's camera for door alarms. Without this endpoint, images stay on the Pi for 7 days.

```
POST /gateway/facility-node/snapshot   Content-Type: multipart/form-data
file      = 20261030T101500Z-main.jpg    (image/jpeg, ~100–400 KB, max 4 MB)
id        = 4be1…                        (also sent as Idempotency-Key)
facility  = 37
name      = 20261030T101500Z-main.jpg
ts        = 2026-10-30T10:15:01Z
camera    = main                         (which camera took it)
```

Uploads are queued **before** their alert, so the image normally arrives first. Link them by `name` = the alert's `snapshot`. Allow up to 30 s per upload and bodies of at least 2 MB. A door propped open for 20 minutes sends about six images. Treat camera images of people as personal data: restrict access and set a retention period.

## Facility app (no backend call)

Attendants open doors from the Facility app, which calls the Pi directly on the facility WiFi. The backend is not in this path. The app gets its door buttons (device id, name, price) from the Pi with `GET /facility/doors`, then opens one:

```
POST http://<pi>:5454/facility/open
{ "authCode": "…", "door": "BHU-002",
  "use": "personal", "purpose": "cleaning",
  "attendant": "rahim", "attendant_id": 615 }
```

Personal use needs the gate, a `purpose`, the `attendant` name and the `attendant_id`; without both the Pi refuses it (`400 no_attendant`). The app finds the Pi by the node's `lan_ip` (`GET …/nodes`). The backend needs only three things from you:

- `authCode` in the settings pull (the Pi checks the app's code against it, offline).
- `doors` in the settings pull, so the app shows names and prices.
- Handling the resulting door events: `attendant`, `denied` (wrong code, no `reason`), or `relay_failed` for a cash sale where the door failed.

## Testing with the dummy backend

The repo includes `facility-node/dev/dummy_backend.py`, a working reference implementation of this contract. It checks the auth header, rejects missing fields with 422, ignores duplicate ids, charges each `scan_id` once, refunds on `relay_failed`, can simulate an outage, and shows a live dashboard of everything a Pi sent. `--jabo` makes `/qr/validate` answer like the Jabo Khotai backend.

```
# laptop or Pi, from the repo
python3 facility-node/dev/dummy_backend.py --host 0.0.0.0 --jabo
# then on the Pi (.env):
#   ADMIN_URL=http://<that-machine>:8091/api   ADMIN_KEY=dummy-key
#   DEVICE_AUTH_CODE=dummy-device-code   (paths and QR_API_* as in .env.example)
# dashboard: http://<that-machine>:8091/
```

To test your real backend against a Pi, set those values on the Pi and run `facility doctor`. It reports the settings pull (401 key, 403 facility, 404 path), and whether `/qr/validate` refuses a fake code or refuses the Pi's setup (Auth Code, door id).

Repository: [github.com/utpaulBS23/bhumijo-gateway-linux](https://github.com/utpaulBS23/bhumijo-gateway-linux). Contract source: `facility-node/README.md` section 8; flow diagrams: `facility-node/API_FLOW.md`.

## Done checklist

Tick these off as you build. The ticks are saved in this browser only.

- [ ] `/qr/validate` checks `Device-Auth-Code` against `facility`, finds the gate by its device id in `door` (`service_id`, `gender`, price), and runs `/user/accesses`
- [ ] Success answers exactly `200 {"message": "Service unlocked"}`; every refusal is a 4xx with the reason in `message`
- [ ] Each `scan_id` is charged once; a repeat returns the first answer
- [ ] `relay_failed` refunds its `scan_id`, or voids the cash sale
- [ ] Settings pull returns `facilityId` and `authCode`; `mac` checked against the Device List
- [ ] Each gate has a device id (`BHU-001`…) given to the field team; `doors` (name, price) sent in the settings pull
- [ ] `cameraDoors` is editable in the admin panel and sent in the settings pull, by device id
- [ ] Door events and alerts stored by `door` (device id); `price` / `price_mismatch` in cash and QR reports
- [ ] `devices` shown in the Device List; `device_mismatch` raises a security alarm
- [ ] One API key per facility, checked against the `facility` field
- [ ] Unique constraint on `id`; a repeated id returns 200 without a second row
- [ ] Status codes follow the retry table: 422 for bad content, never 500 for bad input
- [ ] Events stored and reported by `ts`, not arrival time
- [ ] Handles a catch-up burst (about 1,440 sensor rows per offline day) without rate-limiting
- [ ] `null` sensor values stored as no data
- [ ] Alert handling: `repeat:false` opens, `repeat:true` updates, `*_resolved` closes; notifications wired
- [ ] Facility-offline alarm when no sensor push arrives for 5 minutes
- [ ] HTTPS with a valid certificate; replies within 10 s (QR within 5 s)
- [ ] Unknown extra fields ignored, not rejected
- [ ] Real paths and auth header sent to the field team for `.env`
- [ ] `devices` accepts `expected: null` / `ok: null`, and uses `reachable`
- [ ] A `denied` event with `reason: offline` and a `scan_id` refunds a late charge at once

Facility node backend contract · first written 2 October 2026, updated 5 November 2026 to the backend's feature report and the node's source (uplink.py, door/controller.py, door/qr_api.py, door/info.py, netcheck.py, camera/camera.py, odour/). If code and page ever disagree, `facility-node/README.md` §8 in the repository is the source of truth.