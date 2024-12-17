# > < increase or decrase pointer by 1
# + - increase or decrase the value at the current block
# [ ] loop. when hitting ], if value of current block isn't 0, repeat back to previous [
# , input 1 character
# . print 1 character

data = []
with open("./input") as f:
    for l in f:
        for ch in l:
            data.append(ch)

print(data)


def is_not_whitespace(ch):
    if ch == "\n" or ch == " ":
        return False
    return True


filtered_data = list(filter(is_not_whitespace, data))

print(filtered_data)
