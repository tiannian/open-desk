gpio.mode(0, gpio.OUTPUT)
gpio.mode(1, gpio.OUTPUT)
gpio.mode(2, gpio.OUTPUT)
gpio.write(0, gpio.LOW)

local wifi_config = {}
wifi_config.ssid = "tiannian"
wifi_config.pwd = "381654729"

wifi.setmode(wifi.STATION)

wifi.sta.config(wifi_config)

wifi.sta.connect()

print("hello")

pwm.setup(1, 800, 1023)
pwm.setup(2, 800, 1023)

function up(speed)
    print(speed)
    pwm.setduty(1, speed)
    pwm.start(1)
    gpio.write(2, gpio.LOW)
end

function down(speed)
    print(speed)
    pwm.setduty(2, speed)
    pwm.start(2)
    gpio.write(1, gpio.LOW)
end

function stop()
    pwm.stop(1)
    pwm.stop(2)
    gpio.write(1, gpio.LOW)
    gpio.write(2, gpio.LOW)
end

local status = "stop"

function server_handle(payload)
    local request = sjson.decode(payload)
    if (request.command == "stop") then
        stop()
        print("stop")
        status = "stop"
    elseif (request.command == "up") then
        if status == "stop" or status == "up" then
            up(request.speed)
            print("up", request.speed)
            status = "up"
        end
    elseif (request.command == "down") then
        if status == "stop" or status == "down" then
            down(request.speed)
            print("down", request.speed)
            status = "down"
        end
    end
    return "hello"
end

cs = coap.Server()
cs:listen(5683)
cs:func("server_handle")
