
kernel_int.bin:     file format binary


Disassembly of section .data:

00000000 <.data>:
       0:	3c1a8000 	lui	k0,0x8000
       4:	275a11bc 	addiu	k0,k0,4540
       8:	03400008 	jr	k0
       c:	00000000 	nop
	...
    1180:	3c1a8000 	lui	k0,0x8000
    1184:	275a169c 	addiu	k0,k0,5788
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
    11e4:	40086000 	mfc0	t0,c0_status
    11e8:	00000000 	nop
    11ec:	3909ff07 	xori	t1,t0,0xff07
    11f0:	01094024 	and	t0,t0,t1
    11f4:	40886000 	mtc0	t0,c0_status
    11f8:	00000000 	nop
    11fc:	40086000 	mfc0	t0,c0_status
    1200:	3c090040 	lui	t1,0x40
    1204:	01094826 	xor	t1,t0,t1
    1208:	01094024 	and	t0,t0,t1
    120c:	40886000 	mtc0	t0,c0_status
    1210:	340a1000 	li	t2,0x1000
    1214:	408a7801 	mtc0	t2,$15,1
    1218:	40086800 	mfc0	t0,c0_cause
    121c:	3c090080 	lui	t1,0x80
    1220:	01284826 	xor	t1,t1,t0
    1224:	01094024 	and	t0,t0,t1
    1228:	40886800 	mtc0	t0,c0_cause
    122c:	3c1d8080 	lui	sp,0x8080
    1230:	27bd0000 	addiu	sp,sp,0
    1234:	03a0f025 	move	s8,sp
    1238:	3c08807f 	lui	t0,0x807f
    123c:	25080000 	addiu	t0,t0,0
    1240:	3c09807f 	lui	t1,0x807f
    1244:	ad280070 	sw	t0,112(t1)
    1248:	3c09807f 	lui	t1,0x807f
    124c:	ad280074 	sw	t0,116(t1)
    1250:	3c08bfd0 	lui	t0,0xbfd0
    1254:	34090010 	li	t1,0x10
    1258:	a10903fc 	sb	t1,1020(t0)
    125c:	40086000 	mfc0	t0,c0_status
    1260:	35081000 	ori	t0,t0,0x1000
    1264:	40886000 	mtc0	t0,c0_status
    1268:	34080020 	li	t0,0x20
    126c:	2508ffff 	addiu	t0,t0,-1
    1270:	27bdfffc 	addiu	sp,sp,-4
    1274:	afa00000 	sw	zero,0(sp)
    1278:	1500fffc 	bnez	t0,0x126c
    127c:	00000000 	nop
    1280:	3c08807f 	lui	t0,0x807f
    1284:	25080080 	addiu	t0,t0,128
    1288:	ad1d0000 	sw	sp,0(t0)
    128c:	40096000 	mfc0	t1,c0_status
    1290:	400a6800 	mfc0	t2,c0_cause
    1294:	35290001 	ori	t1,t1,0x1
    1298:	afaa0074 	sw	t2,116(sp)
    129c:	afa90070 	sw	t1,112(sp)
    12a0:	3c0b8000 	lui	t3,0x8000
    12a4:	256b133c 	addiu	t3,t3,4924
    12a8:	afab0078 	sw	t3,120(sp)
    12ac:	03a07025 	move	t6,sp
    12b0:	34080020 	li	t0,0x20
    12b4:	2508ffff 	addiu	t0,t0,-1
    12b8:	27bdfffc 	addiu	sp,sp,-4
    12bc:	afa00000 	sw	zero,0(sp)
    12c0:	1500fffc 	bnez	t0,0x12b4
    12c4:	00000000 	nop
    12c8:	3c08807f 	lui	t0,0x807f
    12cc:	25080080 	addiu	t0,t0,128
    12d0:	ad1d0004 	sw	sp,4(t0)
    12d4:	addd007c 	sw	sp,124(t6)
    12d8:	3c0a807f 	lui	t2,0x807f
    12dc:	254a0084 	addiu	t2,t2,132
    12e0:	8d4a0000 	lw	t2,0(t2)
    12e4:	3c09807f 	lui	t1,0x807f
    12e8:	ad2a0088 	sw	t2,136(t1)
    12ec:	40086000 	mfc0	t0,c0_status
    12f0:	00000000 	nop
    12f4:	35080001 	ori	t0,t0,0x1
    12f8:	39091000 	xori	t1,t0,0x1000
    12fc:	01094024 	and	t0,t0,t1
    1300:	40886000 	mtc0	t0,c0_status
    1304:	00000000 	nop
    1308:	080004c4 	j	0x1310
    130c:	00000000 	nop
    1310:	3c108000 	lui	s0,0x8000
    1314:	26101190 	addiu	s0,s0,4496
    1318:	82040000 	lb	a0,0(s0)
    131c:	26100001 	addiu	s0,s0,1
    1320:	0c00061e 	jal	0x1878
    1324:	00000000 	nop
    1328:	82040000 	lb	a0,0(s0)
    132c:	1480fffb 	bnez	a0,0x131c
    1330:	00000000 	nop
    1334:	080004e9 	j	0x13a4
    1338:	00000000 	nop
	...
    1364:	080004cf 	j	0x133c
    1368:	00000000 	nop
    136c:	3c09807f 	lui	t1,0x807f
    1370:	25290080 	addiu	t1,t1,128
    1374:	8d2a0000 	lw	t2,0(t1)
    1378:	3c0c807f 	lui	t4,0x807f
    137c:	8d8b0088 	lw	t3,136(t4)
    1380:	00000000 	nop
    1384:	154b0003 	bne	t2,t3,0x1394
    1388:	00000000 	nop
    138c:	8d2a0004 	lw	t2,4(t1)
    1390:	00000000 	nop
    1394:	0140e825 	move	sp,t2
    1398:	ad9d0088 	sw	sp,136(t4)
    139c:	080005de 	j	0x1778
    13a0:	00000000 	nop
    13a4:	0c000629 	jal	0x18a4
    13a8:	00000000 	nop
    13ac:	34080052 	li	t0,0x52
    13b0:	10480026 	beq	v0,t0,0x144c
    13b4:	00000000 	nop
    13b8:	34080044 	li	t0,0x44
    13bc:	10480034 	beq	v0,t0,0x1490
    13c0:	00000000 	nop
    13c4:	34080041 	li	t0,0x41
    13c8:	10480046 	beq	v0,t0,0x14e4
    13cc:	00000000 	nop
    13d0:	34080047 	li	t0,0x47
    13d4:	10480059 	beq	v0,t0,0x153c
    13d8:	00000000 	nop
    13dc:	34080054 	li	t0,0x54
    13e0:	10480003 	beq	v0,t0,0x13f0
    13e4:	00000000 	nop
    13e8:	0800059e 	j	0x1678
    13ec:	00000000 	nop
    13f0:	0c000636 	jal	0x18d8
    13f4:	00000000 	nop
    13f8:	27bdffe8 	addiu	sp,sp,-24
    13fc:	afb00000 	sw	s0,0(sp)
    1400:	afb10004 	sw	s1,4(sp)
    1404:	2410ffff 	li	s0,-1
    1408:	afb0000c 	sw	s0,12(sp)
    140c:	afb00010 	sw	s0,16(sp)
    1410:	afb00014 	sw	s0,20(sp)
    1414:	3411000c 	li	s1,0xc
    1418:	27b0000c 	addiu	s0,sp,12
    141c:	82040000 	lb	a0,0(s0)
    1420:	2631ffff 	addiu	s1,s1,-1
    1424:	0c00061e 	jal	0x1878
    1428:	00000000 	nop
    142c:	26100001 	addiu	s0,s0,1
    1430:	1620fffa 	bnez	s1,0x141c
    1434:	00000000 	nop
    1438:	8fb00000 	lw	s0,0(sp)
    143c:	8fb10004 	lw	s1,4(sp)
    1440:	27bd0018 	addiu	sp,sp,24
    1444:	0800059e 	j	0x1678
    1448:	00000000 	nop
    144c:	27bdfff8 	addiu	sp,sp,-8
    1450:	afb00000 	sw	s0,0(sp)
    1454:	afb10004 	sw	s1,4(sp)
    1458:	3c10807f 	lui	s0,0x807f
    145c:	34110078 	li	s1,0x78
    1460:	82040000 	lb	a0,0(s0)
    1464:	2631ffff 	addiu	s1,s1,-1
    1468:	0c00061e 	jal	0x1878
    146c:	00000000 	nop
    1470:	26100001 	addiu	s0,s0,1
    1474:	1620fffa 	bnez	s1,0x1460
    1478:	00000000 	nop
    147c:	8fb00000 	lw	s0,0(sp)
    1480:	8fb10004 	lw	s1,4(sp)
    1484:	27bd0008 	addiu	sp,sp,8
    1488:	0800059e 	j	0x1678
    148c:	00000000 	nop
    1490:	27bdfff8 	addiu	sp,sp,-8
    1494:	afb00000 	sw	s0,0(sp)
    1498:	afb10004 	sw	s1,4(sp)
    149c:	0c000636 	jal	0x18d8
    14a0:	00000000 	nop
    14a4:	00408025 	move	s0,v0
    14a8:	0c000636 	jal	0x18d8
    14ac:	00000000 	nop
    14b0:	00408825 	move	s1,v0
    14b4:	82040000 	lb	a0,0(s0)
    14b8:	2631ffff 	addiu	s1,s1,-1
    14bc:	0c00061e 	jal	0x1878
    14c0:	00000000 	nop
    14c4:	26100001 	addiu	s0,s0,1
    14c8:	1620fffa 	bnez	s1,0x14b4
    14cc:	00000000 	nop
    14d0:	8fb00000 	lw	s0,0(sp)
    14d4:	8fb10004 	lw	s1,4(sp)
    14d8:	27bd0008 	addiu	sp,sp,8
    14dc:	0800059e 	j	0x1678
    14e0:	00000000 	nop
    14e4:	27bdfff8 	addiu	sp,sp,-8
    14e8:	afb00000 	sw	s0,0(sp)
    14ec:	afb10004 	sw	s1,4(sp)
    14f0:	0c000636 	jal	0x18d8
    14f4:	00000000 	nop
    14f8:	00408025 	move	s0,v0
    14fc:	0c000636 	jal	0x18d8
    1500:	00000000 	nop
    1504:	00408825 	move	s1,v0
    1508:	00118882 	srl	s1,s1,0x2
    150c:	0c000636 	jal	0x18d8
    1510:	00000000 	nop
    1514:	ae020000 	sw	v0,0(s0)
    1518:	2631ffff 	addiu	s1,s1,-1
    151c:	26100004 	addiu	s0,s0,4
    1520:	1620fffa 	bnez	s1,0x150c
    1524:	00000000 	nop
    1528:	8fb00000 	lw	s0,0(sp)
    152c:	8fb10004 	lw	s1,4(sp)
    1530:	27bd0008 	addiu	sp,sp,8
    1534:	0800059e 	j	0x1678
    1538:	00000000 	nop
    153c:	0c000636 	jal	0x18d8
    1540:	00000000 	nop
    1544:	34040006 	li	a0,0x6
    1548:	0c00061e 	jal	0x1878
    154c:	00000000 	nop
    1550:	40827000 	mtc0	v0,c0_epc
    1554:	3c1f807f 	lui	ra,0x807f
    1558:	27ff0000 	addiu	ra,ra,0
    155c:	afe20078 	sw	v0,120(ra)
    1560:	affd007c 	sw	sp,124(ra)
    1564:	8fe10000 	lw	at,0(ra)
    1568:	8fe20004 	lw	v0,4(ra)
    156c:	8fe30008 	lw	v1,8(ra)
    1570:	8fe4000c 	lw	a0,12(ra)
    1574:	8fe50010 	lw	a1,16(ra)
    1578:	8fe60014 	lw	a2,20(ra)
    157c:	8fe70018 	lw	a3,24(ra)
    1580:	8fe8001c 	lw	t0,28(ra)
    1584:	8fe90020 	lw	t1,32(ra)
    1588:	8fea0024 	lw	t2,36(ra)
    158c:	8feb0028 	lw	t3,40(ra)
    1590:	8fec002c 	lw	t4,44(ra)
    1594:	8fed0030 	lw	t5,48(ra)
    1598:	8fee0034 	lw	t6,52(ra)
    159c:	8fef0038 	lw	t7,56(ra)
    15a0:	8ff0003c 	lw	s0,60(ra)
    15a4:	8ff10040 	lw	s1,64(ra)
    15a8:	8ff20044 	lw	s2,68(ra)
    15ac:	8ff30048 	lw	s3,72(ra)
    15b0:	8ff4004c 	lw	s4,76(ra)
    15b4:	8ff50050 	lw	s5,80(ra)
    15b8:	8ff60054 	lw	s6,84(ra)
    15bc:	8ff70058 	lw	s7,88(ra)
    15c0:	8ff8005c 	lw	t8,92(ra)
    15c4:	8ff90060 	lw	t9,96(ra)
    15c8:	8ffc006c 	lw	gp,108(ra)
    15cc:	8ffd0070 	lw	sp,112(ra)
    15d0:	8ffe0074 	lw	s8,116(ra)
    15d4:	3c1f8000 	lui	ra,0x8000
    15d8:	27ff15e4 	addiu	ra,ra,5604
    15dc:	00000000 	nop
    15e0:	42000018 	eret
    15e4:	00000000 	nop
    15e8:	3c1f807f 	lui	ra,0x807f
    15ec:	27ff0000 	addiu	ra,ra,0
    15f0:	afe10000 	sw	at,0(ra)
    15f4:	afe20004 	sw	v0,4(ra)
    15f8:	afe30008 	sw	v1,8(ra)
    15fc:	afe4000c 	sw	a0,12(ra)
    1600:	afe50010 	sw	a1,16(ra)
    1604:	afe60014 	sw	a2,20(ra)
    1608:	afe70018 	sw	a3,24(ra)
    160c:	afe8001c 	sw	t0,28(ra)
    1610:	afe90020 	sw	t1,32(ra)
    1614:	afea0024 	sw	t2,36(ra)
    1618:	afeb0028 	sw	t3,40(ra)
    161c:	afec002c 	sw	t4,44(ra)
    1620:	afed0030 	sw	t5,48(ra)
    1624:	afee0034 	sw	t6,52(ra)
    1628:	afef0038 	sw	t7,56(ra)
    162c:	aff0003c 	sw	s0,60(ra)
    1630:	aff10040 	sw	s1,64(ra)
    1634:	aff20044 	sw	s2,68(ra)
    1638:	aff30048 	sw	s3,72(ra)
    163c:	aff4004c 	sw	s4,76(ra)
    1640:	aff50050 	sw	s5,80(ra)
    1644:	aff60054 	sw	s6,84(ra)
    1648:	aff70058 	sw	s7,88(ra)
    164c:	aff8005c 	sw	t8,92(ra)
    1650:	aff90060 	sw	t9,96(ra)
    1654:	affc006c 	sw	gp,108(ra)
    1658:	affd0070 	sw	sp,112(ra)
    165c:	affe0074 	sw	s8,116(ra)
    1660:	8ffd007c 	lw	sp,124(ra)
    1664:	34040007 	li	a0,0x7
    1668:	0c00061e 	jal	0x1878
    166c:	00000000 	nop
    1670:	0800059e 	j	0x1678
    1674:	00000000 	nop
    1678:	080004e9 	j	0x13a4
    167c:	00000000 	nop
    1680:	34040080 	li	a0,0x80
    1684:	0c00061e 	jal	0x1878
    1688:	00000000 	nop
    168c:	3c028000 	lui	v0,0x8000
    1690:	244211bc 	addiu	v0,v0,4540
    1694:	00400008 	jr	v0
    1698:	00000000 	nop
    169c:	401a6000 	mfc0	k0,c0_status
    16a0:	00000000 	nop
    16a4:	3b5b0001 	xori	k1,k0,0x1
    16a8:	037ad024 	and	k0,k1,k0
    16ac:	409a6000 	mtc0	k0,c0_status
    16b0:	3c1a807f 	lui	k0,0x807f
    16b4:	8f5a0088 	lw	k0,136(k0)
    16b8:	af5d007c 	sw	sp,124(k0)
    16bc:	0340e825 	move	sp,k0
    16c0:	afa10000 	sw	at,0(sp)
    16c4:	afa20004 	sw	v0,4(sp)
    16c8:	afa30008 	sw	v1,8(sp)
    16cc:	afa4000c 	sw	a0,12(sp)
    16d0:	afa50010 	sw	a1,16(sp)
    16d4:	afa60014 	sw	a2,20(sp)
    16d8:	afa70018 	sw	a3,24(sp)
    16dc:	afa8001c 	sw	t0,28(sp)
    16e0:	afa90020 	sw	t1,32(sp)
    16e4:	afaa0024 	sw	t2,36(sp)
    16e8:	afab0028 	sw	t3,40(sp)
    16ec:	afac002c 	sw	t4,44(sp)
    16f0:	afad0030 	sw	t5,48(sp)
    16f4:	afae0034 	sw	t6,52(sp)
    16f8:	afaf0038 	sw	t7,56(sp)
    16fc:	afb8003c 	sw	t8,60(sp)
    1700:	afb90040 	sw	t9,64(sp)
    1704:	afb00044 	sw	s0,68(sp)
    1708:	afb10048 	sw	s1,72(sp)
    170c:	afb2004c 	sw	s2,76(sp)
    1710:	afb30050 	sw	s3,80(sp)
    1714:	afb40054 	sw	s4,84(sp)
    1718:	afb50058 	sw	s5,88(sp)
    171c:	afb6005c 	sw	s6,92(sp)
    1720:	afb70060 	sw	s7,96(sp)
    1724:	afbc0064 	sw	gp,100(sp)
    1728:	afbe0068 	sw	s8,104(sp)
    172c:	afbf006c 	sw	ra,108(sp)
    1730:	401a6000 	mfc0	k0,c0_status
    1734:	401b6800 	mfc0	k1,c0_cause
    1738:	afba0070 	sw	k0,112(sp)
    173c:	401a7000 	mfc0	k0,c0_epc
    1740:	afbb0074 	sw	k1,116(sp)
    1744:	afba0078 	sw	k0,120(sp)
    1748:	401a6800 	mfc0	k0,c0_cause
    174c:	00000000 	nop
    1750:	335b00ff 	andi	k1,k0,0xff
    1754:	001bd882 	srl	k1,k1,0x2
    1758:	341a0000 	li	k0,0x0
    175c:	137a002c 	beq	k1,k0,0x1810
    1760:	00000000 	nop
    1764:	341a0008 	li	k0,0x8
    1768:	137a0032 	beq	k1,k0,0x1834
    176c:	00000000 	nop
    1770:	080005a0 	j	0x1680
    1774:	00000000 	nop
    1778:	8fba0070 	lw	k0,112(sp)
    177c:	375a0001 	ori	k0,k0,0x1
    1780:	3b5b0004 	xori	k1,k0,0x4
    1784:	035bd024 	and	k0,k0,k1
    1788:	8fbb0078 	lw	k1,120(sp)
    178c:	409a6000 	mtc0	k0,c0_status
    1790:	409b7000 	mtc0	k1,c0_epc
    1794:	8fa10000 	lw	at,0(sp)
    1798:	8fa20004 	lw	v0,4(sp)
    179c:	8fa30008 	lw	v1,8(sp)
    17a0:	8fa4000c 	lw	a0,12(sp)
    17a4:	8fa50010 	lw	a1,16(sp)
    17a8:	8fa60014 	lw	a2,20(sp)
    17ac:	8fa70018 	lw	a3,24(sp)
    17b0:	8fa8001c 	lw	t0,28(sp)
    17b4:	8fa90020 	lw	t1,32(sp)
    17b8:	8faa0024 	lw	t2,36(sp)
    17bc:	8fab0028 	lw	t3,40(sp)
    17c0:	8fac002c 	lw	t4,44(sp)
    17c4:	8fad0030 	lw	t5,48(sp)
    17c8:	8fae0034 	lw	t6,52(sp)
    17cc:	8faf0038 	lw	t7,56(sp)
    17d0:	8fb8003c 	lw	t8,60(sp)
    17d4:	8fb90040 	lw	t9,64(sp)
    17d8:	8fb00044 	lw	s0,68(sp)
    17dc:	8fb10048 	lw	s1,72(sp)
    17e0:	8fb2004c 	lw	s2,76(sp)
    17e4:	8fb30050 	lw	s3,80(sp)
    17e8:	8fb40054 	lw	s4,84(sp)
    17ec:	8fb50058 	lw	s5,88(sp)
    17f0:	8fb6005c 	lw	s6,92(sp)
    17f4:	8fb70060 	lw	s7,96(sp)
    17f8:	8fbc0064 	lw	gp,100(sp)
    17fc:	8fbe0068 	lw	s8,104(sp)
    1800:	8fbf006c 	lw	ra,108(sp)
    1804:	8fbd007c 	lw	sp,124(sp)
    1808:	42000018 	eret
    180c:	00000000 	nop
    1810:	3c09807f 	lui	t1,0x807f
    1814:	8d290088 	lw	t1,136(t1)
    1818:	3c08807f 	lui	t0,0x807f
    181c:	8d080080 	lw	t0,128(t0)
    1820:	00000000 	nop
    1824:	1509ffd4 	bne	t0,t1,0x1778
    1828:	00000000 	nop
    182c:	080004db 	j	0x136c
    1830:	00000000 	nop
    1834:	8fba0078 	lw	k0,120(sp)
    1838:	275a0004 	addiu	k0,k0,4
    183c:	afba0078 	sw	k0,120(sp)
    1840:	34080003 	li	t0,0x3
    1844:	10480006 	beq	v0,t0,0x1860
    1848:	00000000 	nop
    184c:	3408001e 	li	t0,0x1e
    1850:	10480005 	beq	v0,t0,0x1868
    1854:	00000000 	nop
    1858:	080005de 	j	0x1778
    185c:	00000000 	nop
    1860:	080004db 	j	0x136c
    1864:	00000000 	nop
    1868:	0c00061e 	jal	0x1878
    186c:	00000000 	nop
    1870:	080005de 	j	0x1778
    1874:	00000000 	nop
    1878:	3c09bfd0 	lui	t1,0xbfd0
    187c:	812803fc 	lb	t0,1020(t1)
    1880:	31080001 	andi	t0,t0,0x1
    1884:	15000003 	bnez	t0,0x1894
    1888:	00000000 	nop
    188c:	0800061f 	j	0x187c
    1890:	00000000 	nop
    1894:	3c09bfd0 	lui	t1,0xbfd0
    1898:	a12403f8 	sb	a0,1016(t1)
    189c:	03e00008 	jr	ra
    18a0:	00000000 	nop
    18a4:	3c09bfd0 	lui	t1,0xbfd0
    18a8:	812803fc 	lb	t0,1020(t1)
    18ac:	31080002 	andi	t0,t0,0x2
    18b0:	15000005 	bnez	t0,0x18c8
    18b4:	00000000 	nop
    18b8:	34020003 	li	v0,0x3
    18bc:	0000200c 	syscall	0x80
    18c0:	0800062a 	j	0x18a8
    18c4:	00000000 	nop
    18c8:	3c09bfd0 	lui	t1,0xbfd0
    18cc:	812203f8 	lb	v0,1016(t1)
    18d0:	03e00008 	jr	ra
    18d4:	00000000 	nop
    18d8:	27bdffec 	addiu	sp,sp,-20
    18dc:	afbf0000 	sw	ra,0(sp)
    18e0:	afb00004 	sw	s0,4(sp)
    18e4:	afb10008 	sw	s1,8(sp)
    18e8:	afb2000c 	sw	s2,12(sp)
    18ec:	afb30010 	sw	s3,16(sp)
    18f0:	0c000629 	jal	0x18a4
    18f4:	00000000 	nop
    18f8:	00028025 	or	s0,zero,v0
    18fc:	0c000629 	jal	0x18a4
    1900:	00000000 	nop
    1904:	00028825 	or	s1,zero,v0
    1908:	0c000629 	jal	0x18a4
    190c:	00000000 	nop
    1910:	00029025 	or	s2,zero,v0
    1914:	0c000629 	jal	0x18a4
    1918:	00000000 	nop
    191c:	00029825 	or	s3,zero,v0
    1920:	321000ff 	andi	s0,s0,0xff
    1924:	327300ff 	andi	s3,s3,0xff
    1928:	325200ff 	andi	s2,s2,0xff
    192c:	323100ff 	andi	s1,s1,0xff
    1930:	00131025 	or	v0,zero,s3
    1934:	00021200 	sll	v0,v0,0x8
    1938:	00521025 	or	v0,v0,s2
    193c:	00021200 	sll	v0,v0,0x8
    1940:	00511025 	or	v0,v0,s1
    1944:	00021200 	sll	v0,v0,0x8
    1948:	00501025 	or	v0,v0,s0
    194c:	8fbf0000 	lw	ra,0(sp)
    1950:	8fb00004 	lw	s0,4(sp)
    1954:	8fb10008 	lw	s1,8(sp)
    1958:	8fb2000c 	lw	s2,12(sp)
    195c:	8fb30010 	lw	s3,16(sp)
    1960:	27bd0014 	addiu	sp,sp,20
    1964:	03e00008 	jr	ra
    1968:	00000000 	nop
	...
    2000:	24420001 	addiu	v0,v0,1
    2004:	03e00008 	jr	ra
    2008:	00000000 	nop
    200c:	3402001e 	li	v0,0x1e
    2010:	3404004f 	li	a0,0x4f
    2014:	0000200c 	syscall	0x80
    2018:	00000000 	nop
    201c:	3404004b 	li	a0,0x4b
    2020:	0000200c 	syscall	0x80
    2024:	00000000 	nop
    2028:	03e00008 	jr	ra
    202c:	00000000 	nop
    2030:	3c080400 	lui	t0,0x400
	...
    2040:	2508ffff 	addiu	t0,t0,-1
    2044:	34090000 	li	t1,0x0
    2048:	340a0001 	li	t2,0x1
    204c:	340b0002 	li	t3,0x2
    2050:	1500fffb 	bnez	t0,0x2040
    2054:	00000000 	nop
    2058:	00000000 	nop
    205c:	03e00008 	jr	ra
    2060:	00000000 	nop
    2064:	3c080100 	lui	t0,0x100
    2068:	34090001 	li	t1,0x1
    206c:	340a0002 	li	t2,0x2
    2070:	340b0003 	li	t3,0x3
    2074:	01495026 	xor	t2,t2,t1
    2078:	012a4826 	xor	t1,t1,t2
    207c:	01495026 	xor	t2,t2,t1
    2080:	016a5826 	xor	t3,t3,t2
    2084:	014b5026 	xor	t2,t2,t3
    2088:	016a5826 	xor	t3,t3,t2
    208c:	012b4826 	xor	t1,t1,t3
    2090:	01695826 	xor	t3,t3,t1
    2094:	012b4826 	xor	t1,t1,t3
    2098:	2508ffff 	addiu	t0,t0,-1
    209c:	1500fff5 	bnez	t0,0x2074
    20a0:	00000000 	nop
    20a4:	03e00008 	jr	ra
    20a8:	00000000 	nop
    20ac:	3c080400 	lui	t0,0x400
    20b0:	15000003 	bnez	t0,0x20c0
    20b4:	00000000 	nop
    20b8:	03e00008 	jr	ra
    20bc:	00000000 	nop
    20c0:	08000832 	j	0x20c8
    20c4:	00000000 	nop
    20c8:	2508ffff 	addiu	t0,t0,-1
    20cc:	0800082c 	j	0x20b0
    20d0:	2508ffff 	addiu	t0,t0,-1
    20d4:	00000000 	nop
    20d8:	3c080200 	lui	t0,0x200
    20dc:	27bdfffc 	addiu	sp,sp,-4
    20e0:	afa80000 	sw	t0,0(sp)
    20e4:	8fa90000 	lw	t1,0(sp)
    20e8:	2529ffff 	addiu	t1,t1,-1
    20ec:	afa90000 	sw	t1,0(sp)
    20f0:	8fa80000 	lw	t0,0(sp)
    20f4:	1500fffa 	bnez	t0,0x20e0
    20f8:	00000000 	nop
    20fc:	27bd0004 	addiu	sp,sp,4
    2100:	03e00008 	jr	ra
    2104:	00000000 	nop
