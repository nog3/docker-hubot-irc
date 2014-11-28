# Description:
#   식당 추천
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   뭐먹을까 - 식당을 골라준다
#   식당추천 <식당이름> - 식당을 추천한다
#   식당제거 <식당이름> - 식당을 추천한다
#   식당 - 식당을 추천 순으로 본다.
#
# Author:
#   mnpk <mnncat@gmail.com>


module.exports = (robot) ->
  restaurants =  () -> robot.brain.data.restaurants ?= {}
  names = () -> (name for name, like of restaurants())
  pick_random = (list) -> list[Math.floor(Math.random() * list.length)]

  send_lunch_msg = () ->
    robot.messageRoom('#dev7', "@channel: 밥? 오늘은 #{pick_random(names())}?")

  timer = setInterval ->
    date = new Date()
    if date.getHours() == 12 and date.getMinutes() == 0
      send_lunch_msg()
      clearInterval timer
      daily_timer = setInterval ->
        send_lunch_msg()
      , 24 * 60 * 60 * 1000
  , 60 * 1000

  robot.respond /식당$/, (msg) ->
    names = (name for name, like of restaurants())
    msg.send "#{names.length}개의 식당을 찾았습니다."
    sorted_names = names.sort (a, b) -> restaurants()[b] - restaurants()[a]
    for name in sorted_names
      msg.send "[#{name}] 좋아요 :heart: #{restaurants()[name]}개"

  robot.respond /식당\s+(.+)$/i, (msg) ->
    name = msg.match[1]
    like = restaurants()[name]
    if like 
      msg.send "[#{name}] 좋아요 :heart: #{like}개"
    else
      msg.send "처음 듣는 식당입니다."

  robot.respond /식당추천 (.*)$/i ,(msg) ->
    name = msg.match[1]
    like = restaurants()[name]
    if not like
      like = 0
    like += 1
    restaurants()[name] = like
    msg.send "[#{name}]를 추천하셨습니다. 좋아요 :heart: #{like}개"

  robot.respond /식당제거 (.*)$/i ,(msg) ->
    name = msg.match[1]
    delete restaurants()[name]
    msg.send "[#{name}] 목록에서 제거되었습니다."

  robot.respond /뭐\s*먹/, (msg) ->
    msg.send "#{pick_random(names())}?"
