
## EVSE ChargingStateKind:
- Expected field path: EVSEStatusProfile > EVSEStatus > Event and Status DESE > evse point status > state
  `EVSEStatusProfile.mapping.evseStatus.eventAndStatusDESE[0].PointStatus.state.value`

## EVSE SOC:

- Expected field path: EVSEStatusProfile > EVSEStatus > Event and status DESE > Event and status deao > Event and status deev > soc
    `EVSEStatusProfile.mapping.evseStatus.eventAndStatusDESE[0].eventAndStatusDEAO.eventAndStatusDEEV.Soc.mag`

---

## EVSE Control Limit W Operation: (_Note: DER Dispatch and the One-Line will create these messages, not the adapter_)
- Expected Field Path: EVSEControlProfile > EVSEControl > Control DESE > ESEControlScheduleFSCH > EVSECSG > EVSECurvePoint > Control > limitWOperation
    `EVSEStatusProfile.mapping.evseStatus.eventAndStatusDESE[0].PointStatus.limitWOperation.maxLimParameter.modEna`
    `EVSEStatusProfile.mapping.evseStatus.eventAndStatusDESE[0].PointStatus.limitWOperation.minLimParameter.modEna`
    `EVSEStatusProfile.mapping.evseStatus.eventAndStatusDESE[0].PointStatus.limitWOperation.wMaxSptVal`
    `EVSEStatusProfile.mapping.evseStatus.eventAndStatusDESE[0].PointStatus.limitWOperation.wMinSptVal`

## EVSE Readings (typical mmxu pathing):
- w_net
- pf_net
- q_net
- v_net
```
