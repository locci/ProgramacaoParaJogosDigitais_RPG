zip -r main.zip *
cp main.zip main.love
rm -rf main.zip
love main.love
echo "the game over"