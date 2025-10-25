# Configure OSPF Single Area

**Date**: 2025-10-24  
**Track**: CCNA  
**Duration**: 45 minutes  
**Status**: Completed

---

## Objective

Configure OSPF single area (Area 0) on three routers in a triangle topology. Verify neighbor adjacencies and routing table convergence.

## Configuration Steps

### Step 1: Enable OSPF on R1

```bash
R1(config)# router ospf 1
R1(config-router)# router-id 1.1.1.1
R1(config-router)# network 10.1.1.0 0.0.0.3 area 0
R1(config-router)# network 10.1.2.0 0.0.0.3 area 0
R1(config-router)# network 192.168.1.0 0.0.0.255 area 0
```

**Result**: OSPF process started, router ID set to 1.1.1.1

### Step 2: Enable OSPF on R2

```bash
R2(config)# router ospf 1
R2(config-router)# router-id 2.2.2.2
R2(config-router)# network 10.1.1.0 0.0.0.3 area 0
R2(config-router)# network 10.1.3.0 0.0.0.3 area 0
R2(config-router)# network 192.168.2.0 0.0.0.255 area 0
```

**Result**: OSPF enabled, saw neighbor adjacency form with R1:
```
*Oct 24 14:23:15.789: %OSPF-5-ADJCHG: Process 1, Nbr 1.1.1.1 on GigabitEthernet0/0 from LOADING to FULL
```

### Step 3: Enable OSPF on R3

```bash
R3(config)# router ospf 1
R3(config-router)# router-id 3.3.3.3
R3(config-router)# network 10.1.2.0 0.0.0.3 area 0
R3(config-router)# network 10.1.3.0 0.0.0.3 area 0
R3(config-router)# network 192.168.3.0 0.0.0.255 area 0
```

**Result**: Adjacencies formed with both R1 and R2

### Step 4: Verify Neighbor Adjacencies

```bash
R1# show ip ospf neighbor

Neighbor ID     Pri   State           Dead Time   Address         Interface
2.2.2.2          1    FULL/DR         00:00:39    10.1.1.2        GigabitEthernet0/0
3.3.3.3          1    FULL/BDR        00:00:35    10.1.2.2        GigabitEthernet0/1
```

**Result**: All neighbors in FULL state

### Step 5: Verify Routing Table

```bash
R1# show ip route ospf

     10.0.0.0/8 is variably subnetted, 6 subnets, 2 masks
O       10.1.3.0/30 [110/2] via 10.1.2.2, 00:02:15, GigabitEthernet0/1
                    [110/2] via 10.1.1.2, 00:02:15, GigabitEthernet0/0
O       192.168.2.0/24 [110/2] via 10.1.1.2, 00:02:15, GigabitEthernet0/0
O       192.168.3.0/24 [110/2] via 10.1.2.2, 00:02:15, GigabitEthernet0/1
```

**Result**: All networks learned via OSPF with correct metrics

## ⚠Troubleshooting

### Issue: R2 and R3 Adjacency Not Forming

**Error Message**:
```
*Oct 24 14:25:42.156: %OSPF-5-ADJCHG: Process 1, Nbr 3.3.3.3 on GigabitEthernet0/1 from LOADING to DOWN, Neighbor Down: Dead timer expired
```

**Root Cause**: MTU mismatch - R2 had MTU 1500, R3 had MTU 1400

**Diagnosis**:
```bash
R2# show ip ospf interface Gi0/1 | include MTU
  MTU 1500 bytes, BW 1000000 Kbit/sec
  
R3# show ip ospf interface Gi0/0 | include MTU
  MTU 1400 bytes, BW 1000000 Kbit/sec
```

**Solution**: Set consistent MTU on R3

```bash
R3(config)# interface Gi0/0
R3(config-if)# ip mtu 1500
```

**Result**: Resolved - Adjacency formed immediately

### Issue: Wildcard Mask Typo

Initial configuration on R1:
```bash
R1(config-router)# network 10.1.1.0 0.0.0.255 area 0
```

**Problem**: Used subnet mask instead of wildcard mask

**Solution**: Correct to wildcard mask
```bash
R1(config-router)# no network 10.1.1.0 0.0.0.255 area 0
R1(config-router)# network 10.1.1.0 0.0.0.3 area 0
```

**Result**: Corrected

## Screenshots

- `../../screenshots/ccna/2025-10-24/ospf-neighbor-full.png` - All neighbors in FULL state
- `../../screenshots/ccna/2025-10-24/routing-table-ospf.png` - Routing table with OSPF routes
- `../../screenshots/ccna/2025-10-24/mtu-mismatch-error.png` - Dead timer expired error
- `../../screenshots/ccna/2025-10-24/topology-diagram.png` - Network topology

## References

- [Cisco OSPF Configuration Guide](https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/iproute_ospf/configuration/xe-16/iro-xe-16-book/iro-cfg.html)
- [RFC 2328 - OSPF Version 2](https://www.rfc-editor.org/rfc/rfc2328)
- Related capture: `2025-10-23_15-45_ospf-area-types.md`

## Next Steps

- [ ] Configure OSPF authentication
- [ ] Test failover scenarios
- [ ] Configure passive interfaces on LAN segments
- [ ] Adjust OSPF timers for faster convergence
- [ ] Document multi-area OSPF configuration

## Lessons Learned

1. **Always verify MTU** - MTU mismatches prevent adjacencies but don't generate obvious errors
2. **Wildcard masks are critical** - Easy to confuse with subnet masks
3. **Router ID explicit** - Set manually for predictability
4. **Verification commands** - Use `show ip ospf neighbor` and `show ip route ospf` to confirm
5. **Dead timer** - Default 40 seconds, appears in neighbor table

---

**Capture Status**: Quick Capture (+10 XP)  
**Troubleshooting Bonus**: (+20 XP for documented failures)  
**Total**: +30 XP
