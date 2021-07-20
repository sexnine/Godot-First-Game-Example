extends Node

export (PackedScene) var Enemy
var score


func _ready():
	randomize()
	# new_game()


func game_over():
	$Music.stop()
	$DeathSound.play()
	$ScoreTimer.stop()
	$EnemyTimer.stop()
	$HUD.show_game_over()


func new_game():
	score = 0
	get_tree().call_group("Enemies", "queue_free")
	$Music.play()
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")


func _on_Player_hit():
	game_over()


func _on_EnemyTimer_timeout():
	$EnemyPath/EnemySpawnLocation.offset = randi()
	var enemy = Enemy.instance()
	add_child(enemy)
	var direction = $EnemyPath/EnemySpawnLocation.rotation + PI / 2
	enemy.position = $EnemyPath/EnemySpawnLocation.position
	direction += rand_range(-PI / 4, PI / 4)
	enemy.rotation = direction
	enemy.linear_velocity = Vector2(rand_range(enemy.min_speed, enemy.max_speed), 0)
	enemy.linear_velocity = enemy.linear_velocity.rotated(direction)


func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_StartTimer_timeout():
	$EnemyTimer.start()
	$ScoreTimer.start()
