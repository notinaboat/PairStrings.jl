# PairStrings.jl

Embed `key => value` Pairs in a string.

```
julia> using PairStrings

julia> PairStrings.pairs("Foo :FOO => 1 Bar :BAR => 2")
2-element Array{Pair{Symbol,Int64},1}:
 :FOO => 1
 :BAR => 2

julia> pairs"Foo :FOO => 1 Bar :BAR => 2"
2-element Array{Pair{Symbol,Int64},1}:
 :FOO => 1
 :BAR => 2
 ```

e.g. Define a pin assignment map for a Raspberry Pi GPIO header.

```

julia julia> pins = pairs"""                                R'Pi GPIO Pins                               ┌──────────────┐                               │     1  2     │                               │ 3V3 ■  ■ 5V  │     :RTC*I2C => (2, 3)   (SDA)│   2 ■  ■ 5V  │      AVR*ISP*5V                          (SCL)│   3 ■  ■ GND │                               │   4 ■  ■ 14  │(TX) :CONSOLE*RX => 14                               │ GND ■  ■ 15  │(RX) :CONSOLE*TX => 15                               │  17 ■  ■ 18  │                               │  27 ■  ■ GND │                               │  22 ■  ■ 23  │     :AVR*ISP*RESET => 23                               │ 3V3 ■  ■ 24  │     :AVR*ISP*MOSI  => 24     :SENSOR*MOSI => 10  (MOSI)│  10 ■  ■ GND │      AVR*ISP*GND     :SENSOR*MISO =>  9  (MISO)│   9 ■  ■ 25  │     :AVR*ISP*MISO  => 25     :SENSOR*SCLK => 11  (SCLK)│  11 ■  ■  8  │     :AVR*ISP*CLK   =>  8                               │ GND ■  ■  7  │                          (IDD)│   0 ■  ■  1  │(IDC)     :SENSOR*CS   =>  5        │   5 ■  ■ GND │                               │   6 ■  ■ 12  │                               │  13 ■  ■ GND │                               │  19 ■  ■ 16  │     :LED*ERROR  => 16                               │  26 ■  ■ 20  │     :LED*POWER  => 20                                │ GND ■  ■ 21  │     :LED*STATUS => 21                               │    39  40    │                               └──────────────┘ """ 14-element Array{Pair{Symbol,B} where B,1}:        :RTC*I2C => (2, 3)     :CONSOLE*RX => 14     :CONSOLE*TX => 15  :AVR*ISP*RESET => 23   :AVR*ISP*MOSI => 24    :SENSOR*MOSI => 10    :SENSOR*MISO => 9   :AVR*ISP*MISO => 25    :SENSOR*SCLK => 11    :AVR*ISP*CLK => 8      :SENSOR*CS => 5      :LED*ERROR => 16      :LED*POWER => 20     :LED*STATUS => 21

julia> using PiGPIOMEM

julia> gpio = Dict(k => GPIOPin(v) for (k, v) in pins)

julia> set*output*mode(gpio[:LED_POWER])

julia> gpio[:LED_POWER][] = true ```

