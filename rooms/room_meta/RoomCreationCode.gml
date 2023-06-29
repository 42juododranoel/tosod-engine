// Meta constants

global.PURGABLE_GLOBALS = [
	// Storages
	"store",
	"cache",
	"idmap",
	// Constants
	"APPLICATION",
]


// Run tests if debug mode,
// run application otherwise

if debug_mode {
	gmtest()
} else {
	start_application()
}
