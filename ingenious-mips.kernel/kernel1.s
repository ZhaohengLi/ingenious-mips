
kernel.bin:     file format binary


Disassembly of section .data:

00000000 <.data>:
       0:	3c1a8000 	lui	k0,0x8000
       4:	275a11bc 	addiu	k0,k0,4540
       8:	03400008 	jr	k0
       c:	00000000 	nop
	...
    1180:	3c1a8000 	lui	k0,0x8000
    1184:	275a15c4 	addiu	k0,k0,5572
    1188:	03400008 	jr	k0
    118c:	00000000 	nop
    1190:	494e4f4d 	0x494e4f4d
    1194:	20524f54 	addi	s2,v0,20308
    1198:	20726f66 	addi	s2,v1,28518
    119c:	5350494d 	beql	k0,s0,0x136d4
    11a0:	2d203233 	sltiu	zero,t1,12851
    11a4:	696e6920 	0x696e6920
    11a8:	6c616974 	0x6c616974
    11ac:	64657a69 	0x64657a69
    11b0:	0000002e 	0x2e
    11b4:	807f0000 	lb	ra,0(v1)
    11b8:	807f008c 	lb	ra,140(v1)
    11bc:	3c1a807f 	lui	k0,0x807f
    11c0:	275a0000 	addiu	k0,k0,0
    11c4:	3c1b807f 	lui	k1,0x807f
    11c8:	277b008c 	addiu	k1,k1,140
    11cc:	135b0005 	beq	k0,k1,0x11e4
    11d0:	00000000 	nop
    11d4:	af400000 	sw	zero,0(k0)
    11d8:	275a0004 	addiu	k0,k0,4
    11dc:	1000fffb 	b	0x11cc
    11e0:	00000000 	nop
    11e4:	3c1d8080 	lui	sp,0x8080
    11e8:	27bd0000 	addiu	sp,sp,0
    11ec:	03a0f025 	move	s8,sp
    11f0:	3c08807f 	lui	t0,0x807f
    11f4:	25080000 	addiu	t0,t0,0
    11f8:	3c09807f 	lui	t1,0x807f
    11fc:	ad280070 	sw	t0,112(t1)
    1200:	3c09807f 	lui	t1,0x807f
    1204:	ad280074 	sw	t0,116(t1)
    1208:	3c08bfd0 	lui	t0,0xbfd0
    120c:	34090010 	li	t1,0x10
    1210:	a10903fc 	sb	t1,1020(t0)
    1214:	34080020 	li	t0,0x20
    1218:	2508ffff 	addiu	t0,t0,-1
    121c:	27bdfffc 	addiu	sp,sp,-4
    1220:	afa00000 	sw	zero,0(sp)
    1224:	1500fffc 	bnez	t0,0x1218
    1228:	00000000 	nop
    122c:	3c08807f 	lui	t0,0x807f
    1230:	25080080 	addiu	t0,t0,128
    1234:	ad1d0000 	sw	sp,0(t0)
    1238:	03a07025 	move	t6,sp
    123c:	34080020 	li	t0,0x20
    1240:	2508ffff 	addiu	t0,t0,-1
    1244:	27bdfffc 	addiu	sp,sp,-4
    1248:	afa00000 	sw	zero,0(sp)
    124c:	1500fffc 	bnez	t0,0x1240
    1250:	00000000 	nop
    1254:	3c08807f 	lui	t0,0x807f
    1258:	25080080 	addiu	t0,t0,128
    125c:	ad1d0004 	sw	sp,4(t0)
    1260:	addd007c 	sw	sp,124(t6)
    1264:	3c0a807f 	lui	t2,0x807f
    1268:	254a0084 	addiu	t2,t2,132
    126c:	8d4a0000 	lw	t2,0(t2)
    1270:	3c09807f 	lui	t1,0x807f
    1274:	ad2a0088 	sw	t2,136(t1)
    1278:	080004a0 	j	0x1280
    127c:	00000000 	nop
    1280:	3c108000 	lui	s0,0x8000
    1284:	26101190 	addiu	s0,s0,4496
    1288:	82040000 	lb	a0,0(s0)
    128c:	26100001 	addiu	s0,s0,1
    1290:	0c000573 	jal	0x15cc
    1294:	00000000 	nop
    1298:	82040000 	lb	a0,0(s0)
    129c:	1480fffb 	bnez	a0,0x128c
    12a0:	00000000 	nop
    12a4:	080004b9 	j	0x12e4
    12a8:	00000000 	nop
	...
    12d4:	080004ab 	j	0x12ac
    12d8:	00000000 	nop
    12dc:	1000ffff 	b	0x12dc
    12e0:	00000000 	nop
    12e4:	0c00057e 	jal	0x15f8
    12e8:	00000000 	nop
    12ec:	34080052 	li	t0,0x52
    12f0:	10480026 	beq	v0,t0,0x138c
    12f4:	00000000 	nop
    12f8:	34080044 	li	t0,0x44
    12fc:	10480034 	beq	v0,t0,0x13d0
    1300:	00000000 	nop
    1304:	34080041 	li	t0,0x41
    1308:	10480046 	beq	v0,t0,0x1424
    130c:	00000000 	nop
    1310:	34080047 	li	t0,0x47
    1314:	10480059 	beq	v0,t0,0x147c
    1318:	00000000 	nop
    131c:	34080054 	li	t0,0x54
    1320:	10480003 	beq	v0,t0,0x1330
    1324:	00000000 	nop
    1328:	0800056f 	j	0x15bc
    132c:	00000000 	nop
    1330:	0c000589 	jal	0x1624
    1334:	00000000 	nop
    1338:	27bdffe8 	addiu	sp,sp,-24
    133c:	afb00000 	sw	s0,0(sp)
    1340:	afb10004 	sw	s1,4(sp)
    1344:	2410ffff 	li	s0,-1
    1348:	afb0000c 	sw	s0,12(sp)
    134c:	afb00010 	sw	s0,16(sp)
    1350:	afb00014 	sw	s0,20(sp)
    1354:	3411000c 	li	s1,0xc
    1358:	27b0000c 	addiu	s0,sp,12
    135c:	82040000 	lb	a0,0(s0)
    1360:	2631ffff 	addiu	s1,s1,-1
    1364:	0c000573 	jal	0x15cc
    1368:	00000000 	nop
    136c:	26100001 	addiu	s0,s0,1
    1370:	1620fffa 	bnez	s1,0x135c
    1374:	00000000 	nop
    1378:	8fb00000 	lw	s0,0(sp)
    137c:	8fb10004 	lw	s1,4(sp)
    1380:	27bd0018 	addiu	sp,sp,24
    1384:	0800056f 	j	0x15bc
    1388:	00000000 	nop
    138c:	27bdfff8 	addiu	sp,sp,-8
    1390:	afb00000 	sw	s0,0(sp)
    1394:	afb10004 	sw	s1,4(sp)
    1398:	3c10807f 	lui	s0,0x807f
    139c:	34110078 	li	s1,0x78
    13a0:	82040000 	lb	a0,0(s0)
    13a4:	2631ffff 	addiu	s1,s1,-1
    13a8:	0c000573 	jal	0x15cc
    13ac:	00000000 	nop
    13b0:	26100001 	addiu	s0,s0,1
    13b4:	1620fffa 	bnez	s1,0x13a0
    13b8:	00000000 	nop
    13bc:	8fb00000 	lw	s0,0(sp)
    13c0:	8fb10004 	lw	s1,4(sp)
    13c4:	27bd0008 	addiu	sp,sp,8
    13c8:	0800056f 	j	0x15bc
    13cc:	00000000 	nop
    13d0:	27bdfff8 	addiu	sp,sp,-8
    13d4:	afb00000 	sw	s0,0(sp)
    13d8:	afb10004 	sw	s1,4(sp)
    13dc:	0c000589 	jal	0x1624
    13e0:	00000000 	nop
    13e4:	00408025 	move	s0,v0
    13e8:	0c000589 	jal	0x1624
    13ec:	00000000 	nop
    13f0:	00408825 	move	s1,v0
    13f4:	82040000 	lb	a0,0(s0)
    13f8:	2631ffff 	addiu	s1,s1,-1
    13fc:	0c000573 	jal	0x15cc
    1400:	00000000 	nop
    1404:	26100001 	addiu	s0,s0,1
    1408:	1620fffa 	bnez	s1,0x13f4
    140c:	00000000 	nop
    1410:	8fb00000 	lw	s0,0(sp)
    1414:	8fb10004 	lw	s1,4(sp)
    1418:	27bd0008 	addiu	sp,sp,8
    141c:	0800056f 	j	0x15bc
    1420:	00000000 	nop
    1424:	27bdfff8 	addiu	sp,sp,-8
    1428:	afb00000 	sw	s0,0(sp)
    142c:	afb10004 	sw	s1,4(sp)
    1430:	0c000589 	jal	0x1624
    1434:	00000000 	nop
    1438:	00408025 	move	s0,v0
    143c:	0c000589 	jal	0x1624
    1440:	00000000 	nop
    1444:	00408825 	move	s1,v0
    1448:	00118882 	srl	s1,s1,0x2
    144c:	0c000589 	jal	0x1624
    1450:	00000000 	nop
    1454:	ae020000 	sw	v0,0(s0)
    1458:	2631ffff 	addiu	s1,s1,-1
    145c:	26100004 	addiu	s0,s0,4
    1460:	1620fffa 	bnez	s1,0x144c
    1464:	00000000 	nop
    1468:	8fb00000 	lw	s0,0(sp)
    146c:	8fb10004 	lw	s1,4(sp)
    1470:	27bd0008 	addiu	sp,sp,8
    1474:	0800056f 	j	0x15bc
    1478:	00000000 	nop
    147c:	0c000589 	jal	0x1624
    1480:	00000000 	nop
    1484:	34040006 	li	a0,0x6
    1488:	0c000573 	jal	0x15cc
    148c:	00000000 	nop
    1490:	0040d025 	move	k0,v0
    1494:	3c1f807f 	lui	ra,0x807f
    1498:	27ff0000 	addiu	ra,ra,0
    149c:	afe20078 	sw	v0,120(ra)
    14a0:	affd007c 	sw	sp,124(ra)
    14a4:	8fe10000 	lw	at,0(ra)
    14a8:	8fe20004 	lw	v0,4(ra)
    14ac:	8fe30008 	lw	v1,8(ra)
    14b0:	8fe4000c 	lw	a0,12(ra)
    14b4:	8fe50010 	lw	a1,16(ra)
    14b8:	8fe60014 	lw	a2,20(ra)
    14bc:	8fe70018 	lw	a3,24(ra)
    14c0:	8fe8001c 	lw	t0,28(ra)
    14c4:	8fe90020 	lw	t1,32(ra)
    14c8:	8fea0024 	lw	t2,36(ra)
    14cc:	8feb0028 	lw	t3,40(ra)
    14d0:	8fec002c 	lw	t4,44(ra)
    14d4:	8fed0030 	lw	t5,48(ra)
    14d8:	8fee0034 	lw	t6,52(ra)
    14dc:	8fef0038 	lw	t7,56(ra)
    14e0:	8ff0003c 	lw	s0,60(ra)
    14e4:	8ff10040 	lw	s1,64(ra)
    14e8:	8ff20044 	lw	s2,68(ra)
    14ec:	8ff30048 	lw	s3,72(ra)
    14f0:	8ff4004c 	lw	s4,76(ra)
    14f4:	8ff50050 	lw	s5,80(ra)
    14f8:	8ff60054 	lw	s6,84(ra)
    14fc:	8ff70058 	lw	s7,88(ra)
    1500:	8ff8005c 	lw	t8,92(ra)
    1504:	8ff90060 	lw	t9,96(ra)
    1508:	8ffc006c 	lw	gp,108(ra)
    150c:	8ffd0070 	lw	sp,112(ra)
    1510:	8ffe0074 	lw	s8,116(ra)
    1514:	3c1f8000 	lui	ra,0x8000
    1518:	27ff1528 	addiu	ra,ra,5416
    151c:	00000000 	nop
    1520:	03400008 	jr	k0
    1524:	00000000 	nop
    1528:	00000000 	nop
    152c:	3c1f807f 	lui	ra,0x807f
    1530:	27ff0000 	addiu	ra,ra,0
    1534:	afe10000 	sw	at,0(ra)
    1538:	afe20004 	sw	v0,4(ra)
    153c:	afe30008 	sw	v1,8(ra)
    1540:	afe4000c 	sw	a0,12(ra)
    1544:	afe50010 	sw	a1,16(ra)
    1548:	afe60014 	sw	a2,20(ra)
    154c:	afe70018 	sw	a3,24(ra)
    1550:	afe8001c 	sw	t0,28(ra)
    1554:	afe90020 	sw	t1,32(ra)
    1558:	afea0024 	sw	t2,36(ra)
    155c:	afeb0028 	sw	t3,40(ra)
    1560:	afec002c 	sw	t4,44(ra)
    1564:	afed0030 	sw	t5,48(ra)
    1568:	afee0034 	sw	t6,52(ra)
    156c:	afef0038 	sw	t7,56(ra)
    1570:	aff0003c 	sw	s0,60(ra)
    1574:	aff10040 	sw	s1,64(ra)
    1578:	aff20044 	sw	s2,68(ra)
    157c:	aff30048 	sw	s3,72(ra)
    1580:	aff4004c 	sw	s4,76(ra)
    1584:	aff50050 	sw	s5,80(ra)
    1588:	aff60054 	sw	s6,84(ra)
    158c:	aff70058 	sw	s7,88(ra)
    1590:	aff8005c 	sw	t8,92(ra)
    1594:	aff90060 	sw	t9,96(ra)
    1598:	affc006c 	sw	gp,108(ra)
    159c:	affd0070 	sw	sp,112(ra)
    15a0:	affe0074 	sw	s8,116(ra)
    15a4:	8ffd007c 	lw	sp,124(ra)
    15a8:	34040007 	li	a0,0x7
    15ac:	0c000573 	jal	0x15cc
    15b0:	00000000 	nop
    15b4:	0800056f 	j	0x15bc
    15b8:	00000000 	nop
    15bc:	080004b9 	j	0x12e4
    15c0:	00000000 	nop
    15c4:	1000ffff 	b	0x15c4
    15c8:	00000000 	nop
    15cc:	3c09bfd0 	lui	t1,0xbfd0
    15d0:	812803fc 	lb	t0,1020(t1)
    15d4:	31080001 	andi	t0,t0,0x1
    15d8:	15000003 	bnez	t0,0x15e8
    15dc:	00000000 	nop
    15e0:	08000574 	j	0x15d0
    15e4:	00000000 	nop
    15e8:	3c09bfd0 	lui	t1,0xbfd0
    15ec:	a12403f8 	sb	a0,1016(t1)
    15f0:	03e00008 	jr	ra
    15f4:	00000000 	nop
    15f8:	3c09bfd0 	lui	t1,0xbfd0
    15fc:	812803fc 	lb	t0,1020(t1)
    1600:	31080002 	andi	t0,t0,0x2
    1604:	15000003 	bnez	t0,0x1614
    1608:	00000000 	nop
    160c:	0800057f 	j	0x15fc
    1610:	00000000 	nop
    1614:	3c09bfd0 	lui	t1,0xbfd0
    1618:	812203f8 	lb	v0,1016(t1)
    161c:	03e00008 	jr	ra
    1620:	00000000 	nop
    1624:	27bdffec 	addiu	sp,sp,-20
    1628:	afbf0000 	sw	ra,0(sp)
    162c:	afb00004 	sw	s0,4(sp)
    1630:	afb10008 	sw	s1,8(sp)
    1634:	afb2000c 	sw	s2,12(sp)
    1638:	afb30010 	sw	s3,16(sp)
    163c:	0c00057e 	jal	0x15f8
    1640:	00000000 	nop
    1644:	00028025 	or	s0,zero,v0
    1648:	0c00057e 	jal	0x15f8
    164c:	00000000 	nop
    1650:	00028825 	or	s1,zero,v0
    1654:	0c00057e 	jal	0x15f8
    1658:	00000000 	nop
    165c:	00029025 	or	s2,zero,v0
    1660:	0c00057e 	jal	0x15f8
    1664:	00000000 	nop
    1668:	00029825 	or	s3,zero,v0
    166c:	321000ff 	andi	s0,s0,0xff
    1670:	327300ff 	andi	s3,s3,0xff
    1674:	325200ff 	andi	s2,s2,0xff
    1678:	323100ff 	andi	s1,s1,0xff
    167c:	00131025 	or	v0,zero,s3
    1680:	00021200 	sll	v0,v0,0x8
    1684:	00521025 	or	v0,v0,s2
    1688:	00021200 	sll	v0,v0,0x8
    168c:	00511025 	or	v0,v0,s1
    1690:	00021200 	sll	v0,v0,0x8
    1694:	00501025 	or	v0,v0,s0
    1698:	8fbf0000 	lw	ra,0(sp)
    169c:	8fb00004 	lw	s0,4(sp)
    16a0:	8fb10008 	lw	s1,8(sp)
    16a4:	8fb2000c 	lw	s2,12(sp)
    16a8:	8fb30010 	lw	s3,16(sp)
    16ac:	27bd0014 	addiu	sp,sp,20
    16b0:	03e00008 	jr	ra
    16b4:	00000000 	nop
	...
    2000:	24420001 	addiu	v0,v0,1
    2004:	03e00008 	jr	ra
    2008:	00000000 	nop
    200c:	3c080400 	lui	t0,0x400
	...
    201c:	2508ffff 	addiu	t0,t0,-1
    2020:	34090000 	li	t1,0x0
    2024:	340a0001 	li	t2,0x1
    2028:	340b0002 	li	t3,0x2
    202c:	1500fffb 	bnez	t0,0x201c
    2030:	00000000 	nop
    2034:	00000000 	nop
    2038:	03e00008 	jr	ra
    203c:	00000000 	nop
    2040:	3c080100 	lui	t0,0x100
    2044:	34090001 	li	t1,0x1
    2048:	340a0002 	li	t2,0x2
    204c:	340b0003 	li	t3,0x3
    2050:	01495026 	xor	t2,t2,t1
    2054:	012a4826 	xor	t1,t1,t2
    2058:	01495026 	xor	t2,t2,t1
    205c:	016a5826 	xor	t3,t3,t2
    2060:	014b5026 	xor	t2,t2,t3
    2064:	016a5826 	xor	t3,t3,t2
    2068:	012b4826 	xor	t1,t1,t3
    206c:	01695826 	xor	t3,t3,t1
    2070:	012b4826 	xor	t1,t1,t3
    2074:	2508ffff 	addiu	t0,t0,-1
    2078:	1500fff5 	bnez	t0,0x2050
    207c:	00000000 	nop
    2080:	03e00008 	jr	ra
    2084:	00000000 	nop
    2088:	3c080400 	lui	t0,0x400
    208c:	15000003 	bnez	t0,0x209c
    2090:	00000000 	nop
    2094:	03e00008 	jr	ra
    2098:	00000000 	nop
    209c:	08000829 	j	0x20a4
    20a0:	00000000 	nop
    20a4:	2508ffff 	addiu	t0,t0,-1
    20a8:	08000823 	j	0x208c
    20ac:	2508ffff 	addiu	t0,t0,-1
    20b0:	00000000 	nop
    20b4:	3c080200 	lui	t0,0x200
    20b8:	27bdfffc 	addiu	sp,sp,-4
    20bc:	afa80000 	sw	t0,0(sp)
    20c0:	8fa90000 	lw	t1,0(sp)
    20c4:	2529ffff 	addiu	t1,t1,-1
    20c8:	afa90000 	sw	t1,0(sp)
    20cc:	8fa80000 	lw	t0,0(sp)
    20d0:	1500fffa 	bnez	t0,0x20bc
    20d4:	00000000 	nop
    20d8:	27bd0004 	addiu	sp,sp,4
    20dc:	03e00008 	jr	ra
    20e0:	00000000 	nop
