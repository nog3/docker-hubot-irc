# Description:
#   hubot spying jira
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   None
#
# Author:
#   mnpk <mnncat@gmail.com>

module.exports = (robot) ->
  robot.router.post '/hubot/jira-spy/:room', (req, res) ->
    room = "##{req.params.room}"
    body = req.body
    if body.webhookEvent == 'jira:issue_updated' && body.comment
      issue = "#{body.issue.key} #{body.issue.fields.summary}"
      url = "#{process.env.HUBOT_JIRA_URL}/browse/#{body.issue.key}"
      robot.messageRoom room, "@#{body.comment.author.name}님께서 <#{url}|#{issue}>에 댓글을 달았습니다."
      robot.messageRoom room, "> #{body.comment.body}"

    res.send 'OK'

