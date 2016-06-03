# UICollectionViewStressing
Toy project to stress UICollectionView

## Very fast performBatchUpdates
Asking for performBatchUpdates very fast without waiting for the completion of the previous one can make some properties of the collection view to be in an inconsistent state.

indexPathsForVisibleItems/indexPathForCell returning cells for previous update:

```
BEFORE PERFORM BATCH UPDATES

VISIBLE CELLS 'BEFORE PERFORM BATCH UPDATES [(<NSIndexPath: 0xc000000003c00016> {length = 2, path = 0 - 30}, 0x00007f94e843d1f0), (<NSIndexPath: 0xc000000006400016> {length = 2, path = 0 - 50}, 0x00007f94e84238a0), (<NSIndexPath: 0xc000000004000016> {length = 2, path = 0 - 32}, 0x00007f94e865edf0), (<NSIndexPath: 0xc000000004400016> {length = 2, path = 0 - 34}, 0x00007f94e9c17be0), (<NSIndexPath: 0xc000000001e00016> {length = 2, path = 0 - 15}, 0x00007f94e9a93fa0), (<NSIndexPath: 0xc000000004800016> {length = 2, path = 0 - 36}, 0x00007f94e9a7e290), (<NSIndexPath: 0xc000000002400016> {length = 2, path = 0 - 18}, 0x00007f94e9a6a9c0), (<NSIndexPath: 0xc000000000000016> {length = 2, path = 0 - 0}, 0x00007f94e9a448c0), (<NSIndexPath: 0xc000000000200016> {length = 2, path = 0 - 1}, 0x00007f94e9a9da50), (<NSIndexPath: 0xc000000007e00016> {length = 2, path = 0 - 63}, 0x00007f94e9a950f0), (<NSIndexPath: 0xc000000000400016> {length = 2, path = 0 - 2}, 0x00007f94e9c38d50), (<NSIndexPath: 0xc000000000600016> {length = 2, path = 0 - 3}, 0x00007f94e866c1c0), (<NSIndexPath: 0xc000000005800016> {length = 2, path = 0 - 44}, 0x00007f94e843e890), (<NSIndexPath: 0xc000000000800016> {length = 2, path = 0 - 4}, 0x00007f94e8641470), (<NSIndexPath: 0xc000000003200016> {length = 2, path = 0 - 25}, 0x00007f94e8456630), (<NSIndexPath: 0xc000000000a00016> {length = 2, path = 0 - 5}, 0x00007f94e9bf2620), (<NSIndexPath: 0xc000000003400016> {length = 2, path = 0 - 26}, 0x00007f94e86804e0), (<NSIndexPath: 0xc000000003800016> {length = 2, path = 0 - 28}, 0x00007f94e8645630), (<NSIndexPath: 0xc000000001200016> {length = 2, path = 0 - 9}, 0x00007f94e865d540)]

VISIBLE CELLS 'INSIDE PERFORM BATCH UPDATES [(<NSIndexPath: 0xc000000003c00016> {length = 2, path = 0 - 30}, 0x00007f94e843d1f0), (<NSIndexPath: 0xc000000006400016> {length = 2, path = 0 - 50}, 0x00007f94e84238a0), (<NSIndexPath: 0xc000000004000016> {length = 2, path = 0 - 32}, 0x00007f94e865edf0), (<NSIndexPath: 0xc000000004400016> {length = 2, path = 0 - 34}, 0x00007f94e9c17be0), (<NSIndexPath: 0xc000000001e00016> {length = 2, path = 0 - 15}, 0x00007f94e9a93fa0), (<NSIndexPath: 0xc000000004800016> {length = 2, path = 0 - 36}, 0x00007f94e9a7e290), (<NSIndexPath: 0xc000000002400016> {length = 2, path = 0 - 18}, 0x00007f94e9a6a9c0), (<NSIndexPath: 0xc000000000000016> {length = 2, path = 0 - 0}, 0x00007f94e9a448c0), (<NSIndexPath: 0xc000000000200016> {length = 2, path = 0 - 1}, 0x00007f94e9a9da50), (<NSIndexPath: 0xc000000007e00016> {length = 2, path = 0 - 63}, 0x00007f94e9a950f0), (<NSIndexPath: 0xc000000000400016> {length = 2, path = 0 - 2}, 0x00007f94e9c38d50), (<NSIndexPath: 0xc000000000600016> {length = 2, path = 0 - 3}, 0x00007f94e866c1c0), (<NSIndexPath: 0xc000000005800016> {length = 2, path = 0 - 44}, 0x00007f94e843e890), (<NSIndexPath: 0xc000000000800016> {length = 2, path = 0 - 4}, 0x00007f94e8641470), (<NSIndexPath: 0xc000000003200016> {length = 2, path = 0 - 25}, 0x00007f94e8456630), (<NSIndexPath: 0xc000000000a00016> {length = 2, path = 0 - 5}, 0x00007f94e9bf2620), (<NSIndexPath: 0xc000000003400016> {length = 2, path = 0 - 26}, 0x00007f94e86804e0), (<NSIndexPath: 0xc000000003800016> {length = 2, path = 0 - 28}, 0x00007f94e8645630), (<NSIndexPath: 0xc000000001200016> {length = 2, path = 0 - 9}, 0x00007f94e865d540)]

DELETIONS: [<NSIndexPath: 0xc000000008200016> {length = 2, path = 0 - 65}]
INSERTIONS: [<NSIndexPath: 0xc000000006a00016> {length = 2, path = 0 - 53}, <NSIndexPath: 0xc000000001200016> {length = 2, path = 0 - 9}, <NSIndexPath: 0xc000000008000016> {length = 2, path = 0 - 64}]
MOVE <NSIndexPath: 0xc000000006e00016> {length = 2, path = 0 - 55} -> <NSIndexPath: 0xc000000000000016> {length = 2, path = 0 - 0}
MOVE <NSIndexPath: 0xc000000001c00016> {length = 2, path = 0 - 14} -> <NSIndexPath: 0xc000000000200016> {length = 2, path = 0 - 1}
MOVE <NSIndexPath: 0xc000000001600016> {length = 2, path = 0 - 11} -> <NSIndexPath: 0xc000000000400016> {length = 2, path = 0 - 2}
MOVE <NSIndexPath: 0xc000000002200016> {length = 2, path = 0 - 17} -> <NSIndexPath: 0xc000000000600016> {length = 2, path = 0 - 3}
MOVE <NSIndexPath: 0xc000000005e00016> {length = 2, path = 0 - 47} -> <NSIndexPath: 0xc000000000800016> {length = 2, path = 0 - 4}
MOVE <NSIndexPath: 0xc000000001400016> {length = 2, path = 0 - 10} -> <NSIndexPath: 0xc000000000a00016> {length = 2, path = 0 - 5}
MOVE <NSIndexPath: 0xc000000002400016> {length = 2, path = 0 - 18} -> <NSIndexPath: 0xc000000000c00016> {length = 2, path = 0 - 6}
MOVE <NSIndexPath: 0xc000000002a00016> {length = 2, path = 0 - 21} -> <NSIndexPath: 0xc000000000e00016> {length = 2, path = 0 - 7}
MOVE <NSIndexPath: 0xc000000004000016> {length = 2, path = 0 - 32} -> <NSIndexPath: 0xc000000001000016> {length = 2, path = 0 - 8}
MOVE <NSIndexPath: 0xc000000001200016> {length = 2, path = 0 - 9} -> <NSIndexPath: 0xc000000001400016> {length = 2, path = 0 - 10}
MOVE <NSIndexPath: 0xc000000004800016> {length = 2, path = 0 - 36} -> <NSIndexPath: 0xc000000001600016> {length = 2, path = 0 - 11}
MOVE <NSIndexPath: 0xc000000002800016> {length = 2, path = 0 - 20} -> <NSIndexPath: 0xc000000001800016> {length = 2, path = 0 - 12}
MOVE <NSIndexPath: 0xc000000006600016> {length = 2, path = 0 - 51} -> <NSIndexPath: 0xc000000001a00016> {length = 2, path = 0 - 13}
MOVE <NSIndexPath: 0xc000000003400016> {length = 2, path = 0 - 26} -> <NSIndexPath: 0xc000000001c00016> {length = 2, path = 0 - 14}
MOVE <NSIndexPath: 0xc000000003600016> {length = 2, path = 0 - 27} -> <NSIndexPath: 0xc000000001e00016> {length = 2, path = 0 - 15}
MOVE <NSIndexPath: 0xc000000005000016> {length = 2, path = 0 - 40} -> <NSIndexPath: 0xc000000002000016> {length = 2, path = 0 - 16}
MOVE <NSIndexPath: 0xc000000007000016> {length = 2, path = 0 - 56} -> <NSIndexPath: 0xc000000002200016> {length = 2, path = 0 - 17}
MOVE <NSIndexPath: 0xc000000002c00016> {length = 2, path = 0 - 22} -> <NSIndexPath: 0xc000000002400016> {length = 2, path = 0 - 18}
MOVE <NSIndexPath: 0xc000000007a00016> {length = 2, path = 0 - 61} -> <NSIndexPath: 0xc000000002600016> {length = 2, path = 0 - 19}
MOVE <NSIndexPath: 0xc000000000c00016> {length = 2, path = 0 - 6} -> <NSIndexPath: 0xc000000002800016> {length = 2, path = 0 - 20}
MOVE <NSIndexPath: 0xc000000002600016> {length = 2, path = 0 - 19} -> <NSIndexPath: 0xc000000002a00016> {length = 2, path = 0 - 21}
MOVE <NSIndexPath: 0xc000000005c00016> {length = 2, path = 0 - 46} -> <NSIndexPath: 0xc000000002c00016> {length = 2, path = 0 - 22}
MOVE <NSIndexPath: 0xc000000003e00016> {length = 2, path = 0 - 31} -> <NSIndexPath: 0xc000000002e00016> {length = 2, path = 0 - 23}
MOVE <NSIndexPath: 0xc000000002e00016> {length = 2, path = 0 - 23} -> <NSIndexPath: 0xc000000003000016> {length = 2, path = 0 - 24}
MOVE <NSIndexPath: 0xc000000007600016> {length = 2, path = 0 - 59} -> <NSIndexPath: 0xc000000003200016> {length = 2, path = 0 - 25}
MOVE <NSIndexPath: 0xc000000003a00016> {length = 2, path = 0 - 29} -> <NSIndexPath: 0xc000000003400016> {length = 2, path = 0 - 26}
MOVE <NSIndexPath: 0xc000000001000016> {length = 2, path = 0 - 8} -> <NSIndexPath: 0xc000000003600016> {length = 2, path = 0 - 27}
MOVE <NSIndexPath: 0xc000000007800016> {length = 2, path = 0 - 60} -> <NSIndexPath: 0xc000000003800016> {length = 2, path = 0 - 28}
MOVE <NSIndexPath: 0xc000000007e00016> {length = 2, path = 0 - 63} -> <NSIndexPath: 0xc000000003a00016> {length = 2, path = 0 - 29}
MOVE <NSIndexPath: 0xc000000007c00016> {length = 2, path = 0 - 62} -> <NSIndexPath: 0xc000000003c00016> {length = 2, path = 0 - 30}
MOVE <NSIndexPath: 0xc000000005a00016> {length = 2, path = 0 - 45} -> <NSIndexPath: 0xc000000003e00016> {length = 2, path = 0 - 31}
MOVE <NSIndexPath: 0xc000000006200016> {length = 2, path = 0 - 49} -> <NSIndexPath: 0xc000000004000016> {length = 2, path = 0 - 32}
MOVE <NSIndexPath: 0xc000000004c00016> {length = 2, path = 0 - 38} -> <NSIndexPath: 0xc000000004200016> {length = 2, path = 0 - 33}
MOVE <NSIndexPath: 0xc000000000400016> {length = 2, path = 0 - 2} -> <NSIndexPath: 0xc000000004400016> {length = 2, path = 0 - 34}
MOVE <NSIndexPath: 0xc000000006000016> {length = 2, path = 0 - 48} -> <NSIndexPath: 0xc000000004600016> {length = 2, path = 0 - 35}
MOVE <NSIndexPath: 0xc000000006a00016> {length = 2, path = 0 - 53} -> <NSIndexPath: 0xc000000004800016> {length = 2, path = 0 - 36}
MOVE <NSIndexPath: 0xc000000008000016> {length = 2, path = 0 - 64} -> <NSIndexPath: 0xc000000004a00016> {length = 2, path = 0 - 37}
MOVE <NSIndexPath: 0xc000000007200016> {length = 2, path = 0 - 57} -> <NSIndexPath: 0xc000000004c00016> {length = 2, path = 0 - 38}
MOVE <NSIndexPath: 0xc000000000a00016> {length = 2, path = 0 - 5} -> <NSIndexPath: 0xc000000004e00016> {length = 2, path = 0 - 39}
MOVE <NSIndexPath: 0xc000000003800016> {length = 2, path = 0 - 28} -> <NSIndexPath: 0xc000000005000016> {length = 2, path = 0 - 40}
MOVE <NSIndexPath: 0xc000000000200016> {length = 2, path = 0 - 1} -> <NSIndexPath: 0xc000000005200016> {length = 2, path = 0 - 41}
MOVE <NSIndexPath: 0xc000000005600016> {length = 2, path = 0 - 43} -> <NSIndexPath: 0xc000000005400016> {length = 2, path = 0 - 42}
MOVE <NSIndexPath: 0xc000000000e00016> {length = 2, path = 0 - 7} -> <NSIndexPath: 0xc000000005600016> {length = 2, path = 0 - 43}
MOVE <NSIndexPath: 0xc000000006c00016> {length = 2, path = 0 - 54} -> <NSIndexPath: 0xc000000005800016> {length = 2, path = 0 - 44}
MOVE <NSIndexPath: 0xc000000004e00016> {length = 2, path = 0 - 39} -> <NSIndexPath: 0xc000000005a00016> {length = 2, path = 0 - 45}
MOVE <NSIndexPath: 0xc000000005400016> {length = 2, path = 0 - 42} -> <NSIndexPath: 0xc000000005c00016> {length = 2, path = 0 - 46}
MOVE <NSIndexPath: 0xc000000004400016> {length = 2, path = 0 - 34} -> <NSIndexPath: 0xc000000005e00016> {length = 2, path = 0 - 47}
MOVE <NSIndexPath: 0xc000000003200016> {length = 2, path = 0 - 25} -> <NSIndexPath: 0xc000000006000016> {length = 2, path = 0 - 48}
MOVE <NSIndexPath: 0xc000000000800016> {length = 2, path = 0 - 4} -> <NSIndexPath: 0xc000000006200016> {length = 2, path = 0 - 49}
MOVE <NSIndexPath: 0xc000000006800016> {length = 2, path = 0 - 52} -> <NSIndexPath: 0xc000000006400016> {length = 2, path = 0 - 50}
MOVE <NSIndexPath: 0xc000000005200016> {length = 2, path = 0 - 41} -> <NSIndexPath: 0xc000000006600016> {length = 2, path = 0 - 51}
MOVE <NSIndexPath: 0xc000000006400016> {length = 2, path = 0 - 50} -> <NSIndexPath: 0xc000000006800016> {length = 2, path = 0 - 52}
MOVE <NSIndexPath: 0xc000000003000016> {length = 2, path = 0 - 24} -> <NSIndexPath: 0xc000000006c00016> {length = 2, path = 0 - 54}
MOVE <NSIndexPath: 0xc000000004600016> {length = 2, path = 0 - 35} -> <NSIndexPath: 0xc000000006e00016> {length = 2, path = 0 - 55}
MOVE <NSIndexPath: 0xc000000000000016> {length = 2, path = 0 - 0} -> <NSIndexPath: 0xc000000007000016> {length = 2, path = 0 - 56}
MOVE <NSIndexPath: 0xc000000003c00016> {length = 2, path = 0 - 30} -> <NSIndexPath: 0xc000000007200016> {length = 2, path = 0 - 57}
MOVE <NSIndexPath: 0xc000000005800016> {length = 2, path = 0 - 44} -> <NSIndexPath: 0xc000000007400016> {length = 2, path = 0 - 58}
MOVE <NSIndexPath: 0xc000000001e00016> {length = 2, path = 0 - 15} -> <NSIndexPath: 0xc000000007600016> {length = 2, path = 0 - 59}
MOVE <NSIndexPath: 0xc000000001800016> {length = 2, path = 0 - 12} -> <NSIndexPath: 0xc000000007800016> {length = 2, path = 0 - 60}
MOVE <NSIndexPath: 0xc000000004200016> {length = 2, path = 0 - 33} -> <NSIndexPath: 0xc000000007a00016> {length = 2, path = 0 - 61}
MOVE <NSIndexPath: 0xc000000002000016> {length = 2, path = 0 - 16} -> <NSIndexPath: 0xc000000007c00016> {length = 2, path = 0 - 62}
MOVE <NSIndexPath: 0xc000000000600016> {length = 2, path = 0 - 3} -> <NSIndexPath: 0xc000000007e00016> {length = 2, path = 0 - 63}
MOVE <NSIndexPath: 0xc000000004a00016> {length = 2, path = 0 - 37} -> <NSIndexPath: 0xc000000008200016> {length = 2, path = 0 - 65}
MOVE <NSIndexPath: 0xc000000001a00016> {length = 2, path = 0 - 13} -> <NSIndexPath: 0xc000000008400016> {length = 2, path = 0 - 66}
MOVE <NSIndexPath: 0xc000000007400016> {length = 2, path = 0 - 58} -> <NSIndexPath: 0xc000000008600016> {length = 2, path = 0 - 67}

prepareForReuse 0x00007f94e8647580
cellForItemAtIndexPath: <NSIndexPath: 0xc000000000000016> {length = 2, path = 0 - 0} 0x00007f94e8647580
willDisplayCell: <NSIndexPath: 0xc000000000000016> {length = 2, path = 0 - 0} 0x00007f94e8647580
cellForItemAtIndexPath: <NSIndexPath: 0xc000000000200016> {length = 2, path = 0 - 1} 0x00007f94e8658160
willDisplayCell: <NSIndexPath: 0xc000000000200016> {length = 2, path = 0 - 1} 0x00007f94e8658160
cellForItemAtIndexPath: <NSIndexPath: 0xc000000000400016> {length = 2, path = 0 - 2} 0x00007f94e9a2dc10
configureCell: <NSIndexPath: 0xc000000000400016> {length = 2, path = 0 - 2} 0x00007f94e9a2dc10
willDisplayCell: <NSIndexPath: 0xc000000000400016> {length = 2, path = 0 - 2} 0x00007f94e9a2dc10
cellForItemAtIndexPath: <NSIndexPath: 0xc000000000600016> {length = 2, path = 0 - 3} 0x00007f94e86b73d0
willDisplayCell: <NSIndexPath: 0xc000000000600016> {length = 2, path = 0 - 3} 0x00007f94e86b73d0

VISIBLE CELLS 'AFTER PERFORM BATCH UPDATES [(<NSIndexPath: 0xc000000003c00016> {length = 2, path = 0 - 30}, 0x00007f94e843d1f0), (<NSIndexPath: 0xc000000006400016> {length = 2, path = 0 - 50}, 0x00007f94e84238a0), (<NSIndexPath: 0xc000000004000016> {length = 2, path = 0 - 32}, 0x00007f94e865edf0), (<NSIndexPath: 0xc000000004400016> {length = 2, path = 0 - 34}, 0x00007f94e9c38d50), (<NSIndexPath: 0xc000000007000016> {length = 2, path = 0 - 56}, 0x00007f94e9a448c0), (<NSIndexPath: 0xc000000001e00016> {length = 2, path = 0 - 15}, 0x00007f94e9a93fa0), (<NSIndexPath: 0xc000000004800016> {length = 2, path = 0 - 36}, 0x00007f94e9a7e290), (<NSIndexPath: 0xc000000002400016> {length = 2, path = 0 - 18}, 0x00007f94e9a6a9c0), (<NSIndexPath: 0xc000000004e00016> {length = 2, path = 0 - 39}, 0x00007f94e9bf2620), (<NSIndexPath: 0xc000000005200016> {length = 2, path = 0 - 41}, 0x00007f94e9a9da50), (<NSIndexPath: 0xc000000000000016> {length = 2, path = 0 - 0}, 0x00007f94e8647580), (<NSIndexPath: 0xc000000000200016> {length = 2, path = 0 - 1}, 0x00007f94e8658160), (<NSIndexPath: 0xc000000007e00016> {length = 2, path = 0 - 63}, 0x00007f94e9a950f0), (<NSIndexPath: 0xc000000000400016> {length = 2, path = 0 - 2}, 0x00007f94e9a2dc10), (<NSIndexPath: 0xc000000000600016> {length = 2, path = 0 - 3}, 0x00007f94e86b73d0), (<NSIndexPath: 0xc000000005800016> {length = 2, path = 0 - 44}, 0x00007f94e843e890), (<NSIndexPath: 0xc000000003200016> {length = 2, path = 0 - 25}, 0x00007f94e8456630), (<NSIndexPath: 0xc000000003400016> {length = 2, path = 0 - 26}, 0x00007f94e86804e0), (<NSIndexPath: 0xc000000005e00016> {length = 2, path = 0 - 47}, 0x00007f94e9c17be0), (<NSIndexPath: 0xc000000003800016> {length = 2, path = 0 - 28}, 0x00007f94e8645630), (<NSIndexPath: 0xc000000006200016> {length = 2, path = 0 - 49}, 0x00007f94e8641470), (<NSIndexPath: 0xc000000001200016> {length = 2, path = 0 - 9}, 0x00007f94e865d540)]

AFTER PERFORM BATCH UPDATES

```

Cell at position 30 is 0x00007f94e843d1f0. There's a move 30 -> 57. After the update, 0x00007f94e843d1f0 is still reported on position 30 


## reloadData before performBatchUpdates completes

It can lead to unexpected cells on the collection view: [video](https://github.com/diegosanchezr/UICollectionViewStressing/blob/master/GhostCells/screencast.mov) and [project](https://github.com/diegosanchezr/UICollectionViewStressing/tree/master/GhostCells)

Documentation somehow warns about this: "You should not call this method in the middle of animation blocks where items are being inserted or deleted"
