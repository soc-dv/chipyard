package chipyard

import chisel3._

import org.chipsalliance.cde.config.{Config}


// ---------------------
//serv Configs
// ---------------------

// Multi-core and 32b heterogeneous configs are supported

class ServConfig extends Config(
  new serv.WithNServCores(1) ++
  new chipyard.config.WithInclusiveCacheWriteBytes(4) ++
  new chipyard.config.AbstractConfig
  )
  
class ServArtyConfig extends Config(
  new chipyard.harness.WithDontTouchChipTopPorts(false) ++        // TODO FIX: Don't dontTouch the ports
  new testchipip.soc.WithNoScratchpads ++                         // All memory is the Rocket TCMs
  new freechips.rocketchip.subsystem.WithIncoherentBusTopology ++ // use incoherent bus topology
  new freechips.rocketchip.subsystem.WithNBanks(0) ++             // remove L2$
  new freechips.rocketchip.subsystem.WithNoMemPort ++             // remove backing memory
  new serv.WithNServCores(1) ++                                   // single core
  new chipyard.config.AbstractConfig)

