using PairStrings
using Test

pins = pairs"""
                               R'Pi GPIO Pins
                              ┌──────────────┐
                              │     1  2     │
                              │ 3V3 ■  ■ 5V  │
                         (SDA)│   2 ■  ■ 5V  │      AVR_ISP_5V
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
"""

@test pins isa Vector{Pair{Symbol,Int64}}
@test pins == [
    :CONSOLE_RX => 14,
    :CONSOLE_TX => 15,
 :AVR_ISP_RESET => 23,
  :AVR_ISP_MOSI => 24,
   :SENSOR_MOSI => 10,
   :SENSOR_MISO => 9,
  :AVR_ISP_MISO => 25,
   :SENSOR_SCLK => 11,
   :AVR_ISP_CLK => 8,
     :SENSOR_CS => 5,
     :LED_ERROR => 16,
     :LED_POWER => 20,
    :LED_STATUS => 21
]

@test pairs""" "FOO" => [1,2,3]""" == ["FOO" => [1,2,3]]
@test pairs""" "FOO" => [1, 2, 3]""" == ["FOO" => [1,2,3]]
@test pairs""" "FOO" => (1, 2, 3)""" == ["FOO" => (1,2,3)]
@test pairs""" "FOO" => "1, 2, 3" """ == ["FOO" => "1, 2, 3"]

d = Dict(pairs":A_X => 1 :B_X => 2 :A_Y => 3")
@test PairStrings.prefix_filter(:A_, d) == Dict(:X => 1, :Y => 3)
