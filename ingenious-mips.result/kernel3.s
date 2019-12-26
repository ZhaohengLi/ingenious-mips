
kernel.bin:     file format binary


Disassembly of section .data:

00000000 <.data>:
       0:	3c1a8000 	lui	k0,0x8000
       4:	275a11bc 	addiu	k0,k0,4540
       8:	03400008 	jr	k0
       c:	00000000 	nop
	...
    1000:	401b2000 	mfc0	k1,c0_context
    1004:	8f7a0000 	lw	k0,0(k1)
    1008:	8f7b0008 	lw	k1,8(k1)
    100c:	409a1000 	mtc0	k0,c0_entrylo0
    1010:	409b1800 	mtc0	k1,c0_entrylo1
    1014:	00000000 	nop
    1018:	42000006 	tlbwr
    101c:	42000018 	eret
	...
    1180:	3c1a8000 	lui	k0,0x8000
    1184:	275a182c 	addiu	k0,k0,6188
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
    11b8:	807f5000 	lb	ra,20480(v1)
    11bc:	3c1a807f 	lui	k0,0x807f
    11c0:	275a0000 	addiu	k0,k0,0
    11c4:	3c1b807f 	lui	k1,0x807f
    11c8:	277b5000 	addiu	k1,k1,20480
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
    12a4:	256b14a8 	addiu	t3,t3,5288
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
    12ec:	3c08c000 	lui	t0,0xc000
    12f0:	40802800 	mtc0	zero,c0_pagemask
    12f4:	40882000 	mtc0	t0,c0_context
    12f8:	3c088000 	lui	t0,0x8000
    12fc:	3c09807f 	lui	t1,0x807f
    1300:	ad280070 	sw	t0,112(t1)
    1304:	3c09807f 	lui	t1,0x807f
    1308:	ad280074 	sw	t0,116(t1)
    130c:	400b8001 	mfc0	t3,c0_config1
    1310:	000b5e42 	srl	t3,t3,0x19
    1314:	316b003f 	andi	t3,t3,0x3f
    1318:	256b0001 	addiu	t3,t3,1
    131c:	3c0c8000 	lui	t4,0x8000
    1320:	018c5025 	or	t2,t4,t4
    1324:	40801000 	mtc0	zero,c0_entrylo0
    1328:	40801800 	mtc0	zero,c0_entrylo1
    132c:	256bffff 	addiu	t3,t3,-1
    1330:	254a2000 	addiu	t2,t2,8192
    1334:	408a5000 	mtc0	t2,c0_entryhi
    1338:	00000000 	nop
    133c:	42000008 	tlbp
    1340:	00000000 	nop
    1344:	40090000 	mfc0	t1,c0_index
    1348:	012c4824 	and	t1,t1,t4
    134c:	1120fff8 	beqz	t1,0x1330
    1350:	00000000 	nop
    1354:	408b0000 	mtc0	t3,c0_index
    1358:	00000000 	nop
    135c:	42000002 	tlbwi
    1360:	1560fff2 	bnez	t3,0x132c
    1364:	00000000 	nop
    1368:	3c04807f 	lui	a0,0x807f
    136c:	24841000 	addiu	a0,a0,4096
    1370:	3c080010 	lui	t0,0x10
    1374:	25080000 	addiu	t0,t0,0
    1378:	00084182 	srl	t0,t0,0x6
    137c:	35080007 	ori	t0,t0,0x7
    1380:	340e0300 	li	t6,0x300
    1384:	ac880000 	sw	t0,0(a0)
    1388:	25ceffff 	addiu	t6,t6,-1
    138c:	24840008 	addiu	a0,a0,8
    1390:	25080040 	addiu	t0,t0,64
    1394:	15c0fffb 	bnez	t6,0x1384
    1398:	00000000 	nop
    139c:	3c04807f 	lui	a0,0x807f
    13a0:	24843080 	addiu	a0,a0,12416
    13a4:	3c080040 	lui	t0,0x40
    13a8:	25080000 	addiu	t0,t0,0
    13ac:	00084182 	srl	t0,t0,0x6
    13b0:	35080007 	ori	t0,t0,0x7
    13b4:	340e03f0 	li	t6,0x3f0
    13b8:	ac880000 	sw	t0,0(a0)
    13bc:	25ceffff 	addiu	t6,t6,-1
    13c0:	24840008 	addiu	a0,a0,8
    13c4:	25080040 	addiu	t0,t0,64
    13c8:	15c0fffb 	bnez	t6,0x13b8
    13cc:	00000000 	nop
    13d0:	34080002 	li	t0,0x2
    13d4:	40883000 	mtc0	t0,c0_wired
    13d8:	3c121fff 	lui	s2,0x1fff
    13dc:	3652ffff 	ori	s2,s2,0xffff
    13e0:	40800000 	mtc0	zero,c0_index
    13e4:	3c04807f 	lui	a0,0x807f
    13e8:	24841000 	addiu	a0,a0,4096
    13ec:	00922024 	and	a0,a0,s2
    13f0:	00042182 	srl	a0,a0,0x6
    13f4:	34840003 	ori	a0,a0,0x3
    13f8:	24850040 	addiu	a1,a0,64
    13fc:	40841000 	mtc0	a0,c0_entrylo0
    1400:	40851800 	mtc0	a1,c0_entrylo1
    1404:	3c08c000 	lui	t0,0xc000
    1408:	25080000 	addiu	t0,t0,0
    140c:	40885000 	mtc0	t0,c0_entryhi
    1410:	00000000 	nop
    1414:	42000002 	tlbwi
    1418:	34080001 	li	t0,0x1
    141c:	40880000 	mtc0	t0,c0_index
    1420:	3c04807f 	lui	a0,0x807f
    1424:	24843000 	addiu	a0,a0,12288
    1428:	00922024 	and	a0,a0,s2
    142c:	00042182 	srl	a0,a0,0x6
    1430:	34840003 	ori	a0,a0,0x3
    1434:	24850040 	addiu	a1,a0,64
    1438:	40841000 	mtc0	a0,c0_entrylo0
    143c:	40851800 	mtc0	a1,c0_entrylo1
    1440:	3c08c03f 	lui	t0,0xc03f
    1444:	3508e000 	ori	t0,t0,0xe000
    1448:	40885000 	mtc0	t0,c0_entryhi
    144c:	00000000 	nop
    1450:	42000002 	tlbwi
    1454:	00000000 	nop
    1458:	40086000 	mfc0	t0,c0_status
    145c:	00000000 	nop
    1460:	35080001 	ori	t0,t0,0x1
    1464:	39091000 	xori	t1,t0,0x1000
    1468:	01094024 	and	t0,t0,t1
    146c:	40886000 	mtc0	t0,c0_status
    1470:	00000000 	nop
    1474:	0800051f 	j	0x147c
    1478:	00000000 	nop
    147c:	3c108000 	lui	s0,0x8000
    1480:	26101190 	addiu	s0,s0,4496
    1484:	82040000 	lb	a0,0(s0)
    1488:	26100001 	addiu	s0,s0,1
    148c:	0c000682 	jal	0x1a08
    1490:	00000000 	nop
    1494:	82040000 	lb	a0,0(s0)
    1498:	1480fffb 	bnez	a0,0x1488
    149c:	00000000 	nop
    14a0:	08000544 	j	0x1510
    14a4:	00000000 	nop
	...
    14d0:	0800052a 	j	0x14a8
    14d4:	00000000 	nop
    14d8:	3c09807f 	lui	t1,0x807f
    14dc:	25290080 	addiu	t1,t1,128
    14e0:	8d2a0000 	lw	t2,0(t1)
    14e4:	3c0c807f 	lui	t4,0x807f
    14e8:	8d8b0088 	lw	t3,136(t4)
    14ec:	00000000 	nop
    14f0:	154b0003 	bne	t2,t3,0x1500
    14f4:	00000000 	nop
    14f8:	8d2a0004 	lw	t2,4(t1)
    14fc:	00000000 	nop
    1500:	0140e825 	move	sp,t2
    1504:	ad9d0088 	sw	sp,136(t4)
    1508:	08000642 	j	0x1908
    150c:	00000000 	nop
    1510:	0c00068d 	jal	0x1a34
    1514:	00000000 	nop
    1518:	34080052 	li	t0,0x52
    151c:	1048002f 	beq	v0,t0,0x15dc
    1520:	00000000 	nop
    1524:	34080044 	li	t0,0x44
    1528:	1048003d 	beq	v0,t0,0x1620
    152c:	00000000 	nop
    1530:	34080041 	li	t0,0x41
    1534:	1048004f 	beq	v0,t0,0x1674
    1538:	00000000 	nop
    153c:	34080047 	li	t0,0x47
    1540:	10480062 	beq	v0,t0,0x16cc
    1544:	00000000 	nop
    1548:	34080054 	li	t0,0x54
    154c:	10480003 	beq	v0,t0,0x155c
    1550:	00000000 	nop
    1554:	08000602 	j	0x1808
    1558:	00000000 	nop
    155c:	0c00069a 	jal	0x1a68
    1560:	00000000 	nop
    1564:	27bdffe8 	addiu	sp,sp,-24
    1568:	afb00000 	sw	s0,0(sp)
    156c:	afb10004 	sw	s1,4(sp)
    1570:	40820000 	mtc0	v0,c0_index
    1574:	40115000 	mfc0	s1,c0_entryhi
    1578:	00000000 	nop
    157c:	42000001 	tlbr
    1580:	00000000 	nop
    1584:	40105000 	mfc0	s0,c0_entryhi
    1588:	afb0000c 	sw	s0,12(sp)
    158c:	40101000 	mfc0	s0,c0_entrylo0
    1590:	afb00010 	sw	s0,16(sp)
    1594:	40101800 	mfc0	s0,c0_entrylo1
    1598:	afb00014 	sw	s0,20(sp)
    159c:	40915000 	mtc0	s1,c0_entryhi
    15a0:	00000000 	nop
    15a4:	3411000c 	li	s1,0xc
    15a8:	27b0000c 	addiu	s0,sp,12
    15ac:	82040000 	lb	a0,0(s0)
    15b0:	2631ffff 	addiu	s1,s1,-1
    15b4:	0c000682 	jal	0x1a08
    15b8:	00000000 	nop
    15bc:	26100001 	addiu	s0,s0,1
    15c0:	1620fffa 	bnez	s1,0x15ac
    15c4:	00000000 	nop
    15c8:	8fb00000 	lw	s0,0(sp)
    15cc:	8fb10004 	lw	s1,4(sp)
    15d0:	27bd0018 	addiu	sp,sp,24
    15d4:	08000602 	j	0x1808
    15d8:	00000000 	nop
    15dc:	27bdfff8 	addiu	sp,sp,-8
    15e0:	afb00000 	sw	s0,0(sp)
    15e4:	afb10004 	sw	s1,4(sp)
    15e8:	3c10807f 	lui	s0,0x807f
    15ec:	34110078 	li	s1,0x78
    15f0:	82040000 	lb	a0,0(s0)
    15f4:	2631ffff 	addiu	s1,s1,-1
    15f8:	0c000682 	jal	0x1a08
    15fc:	00000000 	nop
    1600:	26100001 	addiu	s0,s0,1
    1604:	1620fffa 	bnez	s1,0x15f0
    1608:	00000000 	nop
    160c:	8fb00000 	lw	s0,0(sp)
    1610:	8fb10004 	lw	s1,4(sp)
    1614:	27bd0008 	addiu	sp,sp,8
    1618:	08000602 	j	0x1808
    161c:	00000000 	nop
    1620:	27bdfff8 	addiu	sp,sp,-8
    1624:	afb00000 	sw	s0,0(sp)
    1628:	afb10004 	sw	s1,4(sp)
    162c:	0c00069a 	jal	0x1a68
    1630:	00000000 	nop
    1634:	00408025 	move	s0,v0
    1638:	0c00069a 	jal	0x1a68
    163c:	00000000 	nop
    1640:	00408825 	move	s1,v0
    1644:	82040000 	lb	a0,0(s0)
    1648:	2631ffff 	addiu	s1,s1,-1
    164c:	0c000682 	jal	0x1a08
    1650:	00000000 	nop
    1654:	26100001 	addiu	s0,s0,1
    1658:	1620fffa 	bnez	s1,0x1644
    165c:	00000000 	nop
    1660:	8fb00000 	lw	s0,0(sp)
    1664:	8fb10004 	lw	s1,4(sp)
    1668:	27bd0008 	addiu	sp,sp,8
    166c:	08000602 	j	0x1808
    1670:	00000000 	nop
    1674:	27bdfff8 	addiu	sp,sp,-8
    1678:	afb00000 	sw	s0,0(sp)
    167c:	afb10004 	sw	s1,4(sp)
    1680:	0c00069a 	jal	0x1a68
    1684:	00000000 	nop
    1688:	00408025 	move	s0,v0
    168c:	0c00069a 	jal	0x1a68
    1690:	00000000 	nop
    1694:	00408825 	move	s1,v0
    1698:	00118882 	srl	s1,s1,0x2
    169c:	0c00069a 	jal	0x1a68
    16a0:	00000000 	nop
    16a4:	ae020000 	sw	v0,0(s0)
    16a8:	2631ffff 	addiu	s1,s1,-1
    16ac:	26100004 	addiu	s0,s0,4
    16b0:	1620fffa 	bnez	s1,0x169c
    16b4:	00000000 	nop
    16b8:	8fb00000 	lw	s0,0(sp)
    16bc:	8fb10004 	lw	s1,4(sp)
    16c0:	27bd0008 	addiu	sp,sp,8
    16c4:	08000602 	j	0x1808
    16c8:	00000000 	nop
    16cc:	0c00069a 	jal	0x1a68
    16d0:	00000000 	nop
    16d4:	34040006 	li	a0,0x6
    16d8:	0c000682 	jal	0x1a08
    16dc:	00000000 	nop
    16e0:	40827000 	mtc0	v0,c0_epc
    16e4:	3c1f807f 	lui	ra,0x807f
    16e8:	27ff0000 	addiu	ra,ra,0
    16ec:	afe20078 	sw	v0,120(ra)
    16f0:	affd007c 	sw	sp,124(ra)
    16f4:	8fe10000 	lw	at,0(ra)
    16f8:	8fe20004 	lw	v0,4(ra)
    16fc:	8fe30008 	lw	v1,8(ra)
    1700:	8fe4000c 	lw	a0,12(ra)
    1704:	8fe50010 	lw	a1,16(ra)
    1708:	8fe60014 	lw	a2,20(ra)
    170c:	8fe70018 	lw	a3,24(ra)
    1710:	8fe8001c 	lw	t0,28(ra)
    1714:	8fe90020 	lw	t1,32(ra)
    1718:	8fea0024 	lw	t2,36(ra)
    171c:	8feb0028 	lw	t3,40(ra)
    1720:	8fec002c 	lw	t4,44(ra)
    1724:	8fed0030 	lw	t5,48(ra)
    1728:	8fee0034 	lw	t6,52(ra)
    172c:	8fef0038 	lw	t7,56(ra)
    1730:	8ff0003c 	lw	s0,60(ra)
    1734:	8ff10040 	lw	s1,64(ra)
    1738:	8ff20044 	lw	s2,68(ra)
    173c:	8ff30048 	lw	s3,72(ra)
    1740:	8ff4004c 	lw	s4,76(ra)
    1744:	8ff50050 	lw	s5,80(ra)
    1748:	8ff60054 	lw	s6,84(ra)
    174c:	8ff70058 	lw	s7,88(ra)
    1750:	8ff8005c 	lw	t8,92(ra)
    1754:	8ff90060 	lw	t9,96(ra)
    1758:	8ffc006c 	lw	gp,108(ra)
    175c:	8ffd0070 	lw	sp,112(ra)
    1760:	8ffe0074 	lw	s8,116(ra)
    1764:	3c1f8000 	lui	ra,0x8000
    1768:	27ff1774 	addiu	ra,ra,6004
    176c:	00000000 	nop
    1770:	42000018 	eret
    1774:	00000000 	nop
    1778:	3c1f807f 	lui	ra,0x807f
    177c:	27ff0000 	addiu	ra,ra,0
    1780:	afe10000 	sw	at,0(ra)
    1784:	afe20004 	sw	v0,4(ra)
    1788:	afe30008 	sw	v1,8(ra)
    178c:	afe4000c 	sw	a0,12(ra)
    1790:	afe50010 	sw	a1,16(ra)
    1794:	afe60014 	sw	a2,20(ra)
    1798:	afe70018 	sw	a3,24(ra)
    179c:	afe8001c 	sw	t0,28(ra)
    17a0:	afe90020 	sw	t1,32(ra)
    17a4:	afea0024 	sw	t2,36(ra)
    17a8:	afeb0028 	sw	t3,40(ra)
    17ac:	afec002c 	sw	t4,44(ra)
    17b0:	afed0030 	sw	t5,48(ra)
    17b4:	afee0034 	sw	t6,52(ra)
    17b8:	afef0038 	sw	t7,56(ra)
    17bc:	aff0003c 	sw	s0,60(ra)
    17c0:	aff10040 	sw	s1,64(ra)
    17c4:	aff20044 	sw	s2,68(ra)
    17c8:	aff30048 	sw	s3,72(ra)
    17cc:	aff4004c 	sw	s4,76(ra)
    17d0:	aff50050 	sw	s5,80(ra)
    17d4:	aff60054 	sw	s6,84(ra)
    17d8:	aff70058 	sw	s7,88(ra)
    17dc:	aff8005c 	sw	t8,92(ra)
    17e0:	aff90060 	sw	t9,96(ra)
    17e4:	affc006c 	sw	gp,108(ra)
    17e8:	affd0070 	sw	sp,112(ra)
    17ec:	affe0074 	sw	s8,116(ra)
    17f0:	8ffd007c 	lw	sp,124(ra)
    17f4:	34040007 	li	a0,0x7
    17f8:	0c000682 	jal	0x1a08
    17fc:	00000000 	nop
    1800:	08000602 	j	0x1808
    1804:	00000000 	nop
    1808:	08000544 	j	0x1510
    180c:	00000000 	nop
    1810:	34040080 	li	a0,0x80
    1814:	0c000682 	jal	0x1a08
    1818:	00000000 	nop
    181c:	3c028000 	lui	v0,0x8000
    1820:	244211bc 	addiu	v0,v0,4540
    1824:	00400008 	jr	v0
    1828:	00000000 	nop
    182c:	401a6000 	mfc0	k0,c0_status
    1830:	00000000 	nop
    1834:	3b5b0001 	xori	k1,k0,0x1
    1838:	037ad024 	and	k0,k1,k0
    183c:	409a6000 	mtc0	k0,c0_status
    1840:	3c1a807f 	lui	k0,0x807f
    1844:	8f5a0088 	lw	k0,136(k0)
    1848:	af5d007c 	sw	sp,124(k0)
    184c:	0340e825 	move	sp,k0
    1850:	afa10000 	sw	at,0(sp)
    1854:	afa20004 	sw	v0,4(sp)
    1858:	afa30008 	sw	v1,8(sp)
    185c:	afa4000c 	sw	a0,12(sp)
    1860:	afa50010 	sw	a1,16(sp)
    1864:	afa60014 	sw	a2,20(sp)
    1868:	afa70018 	sw	a3,24(sp)
    186c:	afa8001c 	sw	t0,28(sp)
    1870:	afa90020 	sw	t1,32(sp)
    1874:	afaa0024 	sw	t2,36(sp)
    1878:	afab0028 	sw	t3,40(sp)
    187c:	afac002c 	sw	t4,44(sp)
    1880:	afad0030 	sw	t5,48(sp)
    1884:	afae0034 	sw	t6,52(sp)
    1888:	afaf0038 	sw	t7,56(sp)
    188c:	afb8003c 	sw	t8,60(sp)
    1890:	afb90040 	sw	t9,64(sp)
    1894:	afb00044 	sw	s0,68(sp)
    1898:	afb10048 	sw	s1,72(sp)
    189c:	afb2004c 	sw	s2,76(sp)
    18a0:	afb30050 	sw	s3,80(sp)
    18a4:	afb40054 	sw	s4,84(sp)
    18a8:	afb50058 	sw	s5,88(sp)
    18ac:	afb6005c 	sw	s6,92(sp)
    18b0:	afb70060 	sw	s7,96(sp)
    18b4:	afbc0064 	sw	gp,100(sp)
    18b8:	afbe0068 	sw	s8,104(sp)
    18bc:	afbf006c 	sw	ra,108(sp)
    18c0:	401a6000 	mfc0	k0,c0_status
    18c4:	401b6800 	mfc0	k1,c0_cause
    18c8:	afba0070 	sw	k0,112(sp)
    18cc:	401a7000 	mfc0	k0,c0_epc
    18d0:	afbb0074 	sw	k1,116(sp)
    18d4:	afba0078 	sw	k0,120(sp)
    18d8:	401a6800 	mfc0	k0,c0_cause
    18dc:	00000000 	nop
    18e0:	335b00ff 	andi	k1,k0,0xff
    18e4:	001bd882 	srl	k1,k1,0x2
    18e8:	341a0000 	li	k0,0x0
    18ec:	137a002c 	beq	k1,k0,0x19a0
    18f0:	00000000 	nop
    18f4:	341a0008 	li	k0,0x8
    18f8:	137a0032 	beq	k1,k0,0x19c4
    18fc:	00000000 	nop
    1900:	08000604 	j	0x1810
    1904:	00000000 	nop
    1908:	8fba0070 	lw	k0,112(sp)
    190c:	375a0001 	ori	k0,k0,0x1
    1910:	3b5b0004 	xori	k1,k0,0x4
    1914:	035bd024 	and	k0,k0,k1
    1918:	8fbb0078 	lw	k1,120(sp)
    191c:	409a6000 	mtc0	k0,c0_status
    1920:	409b7000 	mtc0	k1,c0_epc
    1924:	8fa10000 	lw	at,0(sp)
    1928:	8fa20004 	lw	v0,4(sp)
    192c:	8fa30008 	lw	v1,8(sp)
    1930:	8fa4000c 	lw	a0,12(sp)
    1934:	8fa50010 	lw	a1,16(sp)
    1938:	8fa60014 	lw	a2,20(sp)
    193c:	8fa70018 	lw	a3,24(sp)
    1940:	8fa8001c 	lw	t0,28(sp)
    1944:	8fa90020 	lw	t1,32(sp)
    1948:	8faa0024 	lw	t2,36(sp)
    194c:	8fab0028 	lw	t3,40(sp)
    1950:	8fac002c 	lw	t4,44(sp)
    1954:	8fad0030 	lw	t5,48(sp)
    1958:	8fae0034 	lw	t6,52(sp)
    195c:	8faf0038 	lw	t7,56(sp)
    1960:	8fb8003c 	lw	t8,60(sp)
    1964:	8fb90040 	lw	t9,64(sp)
    1968:	8fb00044 	lw	s0,68(sp)
    196c:	8fb10048 	lw	s1,72(sp)
    1970:	8fb2004c 	lw	s2,76(sp)
    1974:	8fb30050 	lw	s3,80(sp)
    1978:	8fb40054 	lw	s4,84(sp)
    197c:	8fb50058 	lw	s5,88(sp)
    1980:	8fb6005c 	lw	s6,92(sp)
    1984:	8fb70060 	lw	s7,96(sp)
    1988:	8fbc0064 	lw	gp,100(sp)
    198c:	8fbe0068 	lw	s8,104(sp)
    1990:	8fbf006c 	lw	ra,108(sp)
    1994:	8fbd007c 	lw	sp,124(sp)
    1998:	42000018 	eret
    199c:	00000000 	nop
    19a0:	3c09807f 	lui	t1,0x807f
    19a4:	8d290088 	lw	t1,136(t1)
    19a8:	3c08807f 	lui	t0,0x807f
    19ac:	8d080080 	lw	t0,128(t0)
    19b0:	00000000 	nop
    19b4:	1509ffd4 	bne	t0,t1,0x1908
    19b8:	00000000 	nop
    19bc:	08000536 	j	0x14d8
    19c0:	00000000 	nop
    19c4:	8fba0078 	lw	k0,120(sp)
    19c8:	275a0004 	addiu	k0,k0,4
    19cc:	afba0078 	sw	k0,120(sp)
    19d0:	34080003 	li	t0,0x3
    19d4:	10480006 	beq	v0,t0,0x19f0
    19d8:	00000000 	nop
    19dc:	3408001e 	li	t0,0x1e
    19e0:	10480005 	beq	v0,t0,0x19f8
    19e4:	00000000 	nop
    19e8:	08000642 	j	0x1908
    19ec:	00000000 	nop
    19f0:	08000536 	j	0x14d8
    19f4:	00000000 	nop
    19f8:	0c000682 	jal	0x1a08
    19fc:	00000000 	nop
    1a00:	08000642 	j	0x1908
    1a04:	00000000 	nop
    1a08:	3c09bfd0 	lui	t1,0xbfd0
    1a0c:	812803fc 	lb	t0,1020(t1)
    1a10:	31080001 	andi	t0,t0,0x1
    1a14:	15000003 	bnez	t0,0x1a24
    1a18:	00000000 	nop
    1a1c:	08000683 	j	0x1a0c
    1a20:	00000000 	nop
    1a24:	3c09bfd0 	lui	t1,0xbfd0
    1a28:	a12403f8 	sb	a0,1016(t1)
    1a2c:	03e00008 	jr	ra
    1a30:	00000000 	nop
    1a34:	3c09bfd0 	lui	t1,0xbfd0
    1a38:	812803fc 	lb	t0,1020(t1)
    1a3c:	31080002 	andi	t0,t0,0x2
    1a40:	15000005 	bnez	t0,0x1a58
    1a44:	00000000 	nop
    1a48:	34020003 	li	v0,0x3
    1a4c:	0000200c 	syscall	0x80
    1a50:	0800068e 	j	0x1a38
    1a54:	00000000 	nop
    1a58:	3c09bfd0 	lui	t1,0xbfd0
    1a5c:	812203f8 	lb	v0,1016(t1)
    1a60:	03e00008 	jr	ra
    1a64:	00000000 	nop
    1a68:	27bdffec 	addiu	sp,sp,-20
    1a6c:	afbf0000 	sw	ra,0(sp)
    1a70:	afb00004 	sw	s0,4(sp)
    1a74:	afb10008 	sw	s1,8(sp)
    1a78:	afb2000c 	sw	s2,12(sp)
    1a7c:	afb30010 	sw	s3,16(sp)
    1a80:	0c00068d 	jal	0x1a34
    1a84:	00000000 	nop
    1a88:	00028025 	or	s0,zero,v0
    1a8c:	0c00068d 	jal	0x1a34
    1a90:	00000000 	nop
    1a94:	00028825 	or	s1,zero,v0
    1a98:	0c00068d 	jal	0x1a34
    1a9c:	00000000 	nop
    1aa0:	00029025 	or	s2,zero,v0
    1aa4:	0c00068d 	jal	0x1a34
    1aa8:	00000000 	nop
    1aac:	00029825 	or	s3,zero,v0
    1ab0:	321000ff 	andi	s0,s0,0xff
    1ab4:	327300ff 	andi	s3,s3,0xff
    1ab8:	325200ff 	andi	s2,s2,0xff
    1abc:	323100ff 	andi	s1,s1,0xff
    1ac0:	00131025 	or	v0,zero,s3
    1ac4:	00021200 	sll	v0,v0,0x8
    1ac8:	00521025 	or	v0,v0,s2
    1acc:	00021200 	sll	v0,v0,0x8
    1ad0:	00511025 	or	v0,v0,s1
    1ad4:	00021200 	sll	v0,v0,0x8
    1ad8:	00501025 	or	v0,v0,s0
    1adc:	8fbf0000 	lw	ra,0(sp)
    1ae0:	8fb00004 	lw	s0,4(sp)
    1ae4:	8fb10008 	lw	s1,8(sp)
    1ae8:	8fb2000c 	lw	s2,12(sp)
    1aec:	8fb30010 	lw	s3,16(sp)
    1af0:	27bd0014 	addiu	sp,sp,20
    1af4:	03e00008 	jr	ra
    1af8:	00000000 	nop
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
