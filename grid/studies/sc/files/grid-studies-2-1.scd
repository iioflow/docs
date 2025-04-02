(
Server.default = Server.local;

// MonomeGrid accepts three arguments:
// * rotation (0 is default)
// * prefix (a string nickname for this grid)
// * fps (frames per second)

~m = MonomeGrid.new();

s.waitForBoot({

	~m.connect(); // 0 (or not supplying any argument) means the first-connected device

	~m.key({
		arg x,y,z;
		[x,y,z, "serial: " ++~m.serial,"port: "++~m.port].postln;
	});

});

)