"""
# PairStrings.jl

Embed `key => value` Pairs in a string.

e.g. Define a pin assignment map for a Raspberry Pi GPIO header.

```julia
julia> using PairStrings

julia> pins = pairs\"\"\"
                               R'Pi GPIO Pins
                              ┌──────────────┐
                              │     1  2     │
                              │ 3V3 ■  ■ 5V  │
    :RTC_I2C => (2, 3)   (SDA)│   2 ■  ■ 5V  │      AVR_ISP_5V
                         (SCL)│   3 ■  ■ GND │
                              │   4 ■  ■ 14  │(TX) :CONSOLE_RX => 14
                              │ GND ■  ■ 15  │(RX) :CONSOLE_TX => 15
                              │  17 ■  ■ 18  │
                              │  27 ■  ■ GND │
                              │  22 ■  ■ 23  │     :AVR_ISP_RESET => 23
                              │ 3V3 ■  ■ 24  │     :AVR_ISP_MOSI  => 24
    :SENSOR_MOSI => 10  (MOSI)│  10 ■  ■ GND │      AVR_ISP_GND
    :SENSOR_MISO =>  9  (MISO)│   9 ■  ■ 25  │     :AVR_ISP_MISO  => 25
    :SENSOR_SCLK => 11  (SCLK)│  11 ■  ■  8  │     :AVR_ISP_CLK   =>  8
                              │ GND ■  ■  7  │
                         (IDD)│   0 ■  ■  1  │(IDC)
    :SENSOR_CS   =>  5        │   5 ■  ■ GND │
                              │   6 ■  ■ 12  │
                              │  13 ■  ■ GND │
                              │  19 ■  ■ 16  │     :LED_ERROR  => 16
                              │  26 ■  ■ 20  │     :LED_POWER  => 20 
                              │ GND ■  ■ 21  │     :LED_STATUS => 21
                              │    39  40    │
                              └──────────────┘
\"\"\"
14-element Array{Pair{Symbol,B} where B,1}:
       :RTC_I2C => (2, 3)
    :CONSOLE_RX => 14
    :CONSOLE_TX => 15
 :AVR_ISP_RESET => 23
  :AVR_ISP_MOSI => 24
   :SENSOR_MOSI => 10
   :SENSOR_MISO => 9
  :AVR_ISP_MISO => 25
   :SENSOR_SCLK => 11
   :AVR_ISP_CLK => 8
     :SENSOR_CS => 5
     :LED_ERROR => 16
     :LED_POWER => 20
    :LED_STATUS => 21


julia> using PiGPIOMEM

julia> gpio = Dict(k => GPIOPin(v) for (k, v) in pins)

julia> set_output_mode(gpio[:LED_POWER])

julia> gpio[:LED_POWER][] = true
```
"""
module PairStrings

export @pairs_str


"""
Match `key => value`,
      `key => "value",
      `key => (value)` or
      `key => [value]`
"""
const pair_pattern = r"""
    [^\s]+           # Pair key. Any non-whitespace characters.
    \s*              # Optional whitespace.
    =>               # Pair operator.
    \s*              # Optional whitespace.
    (  \[ [^\]]* \]  # Pair value. `[ ... ]`
     | \(  [^)]* \)  #             `( ... )`
     |  "  [^"]*  "  #             `" ... "`
     |    [^\s]+     #             Any non-whitespace characters.
    )
"""x


"""
    match_pair(string, [i=1]) => Pair, next_i

Search for `a => b` in `string` (starting at index `i`).
"""
function match_pair(s, i=1)
    m = match(pair_pattern, s, i)
    if m == nothing
        m, i
    else
        pair = include_string(@__MODULE__,m.match)
        i = m.offset + length(m.match)
        pair, i
    end
end


"""
    pairs"Foo :a => 1 Bar :b => 2" => [:a => 1, :b => 2]"

Extract `Vector{Pair}` from a string.
"""
macro pairs_str(s)
    result = []
    pair, i = match_pair(s)
    while pair != nothing
        push!(result, pair)
        pair, i = match_pair(s, i)
    end
    [x for x in result]
end


end # module PairStrings
