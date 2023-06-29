// Meta constants

global.PURGABLE_GLOBALS = [
	"store",
	"cache",
	"idmap",
	"C",
]


// Run tests if debug mode

if debug_mode {
	gmtest()
}
