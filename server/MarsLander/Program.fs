// Learn more about F# at http://fsharp.org

open System

[<EntryPoint>]
let main argv =
    let velocity = Velocity.getLanderVelocity ()
    let altitude = Altitude.getLanderAltitude ()   
    let timeToImpact = Impact.timeToImpact velocity altitude
    printf "Time to impact: %f" timeToImpact
    0 // return an integer exit code
