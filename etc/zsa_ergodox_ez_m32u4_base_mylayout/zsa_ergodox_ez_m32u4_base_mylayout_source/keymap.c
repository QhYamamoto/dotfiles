#include QMK_KEYBOARD_H
#include "version.h"
#include "i18n.h"

enum custom_keycodes {
  RGB_SLD = EZ_SAFE_RANGE,
  ST_MACRO_0,
  ST_MACRO_1,
  ST_MACRO_2,
  ST_MACRO_3,
  ST_MACRO_4,
  ST_MACRO_5,
  ST_MACRO_6,
};


enum tap_dance_codes {
  DANCE_0,
  DANCE_1,
  DANCE_2,
  DANCE_3,
  DANCE_4,
  DANCE_5,
  DANCE_6,
  DANCE_7,
  DANCE_8,
  DANCE_9,
  DANCE_10,
  DANCE_11,
};

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
  [0] = LAYOUT_ergodox_pretty(
    TD(DANCE_0),    LCTL(RSFT(KC_T)),JP_HENK,        KC_F8,          KC_F7,          LALT(LCTL(KC_D)),LALT(LCTL(KC_S)),                                LCTL(RALT(KC_W)),LCTL(RALT(KC_A)),KC_F9,          KC_F10,         KC_F6,          KC_F12,         KC_APPLICATION,
    KC_TAB,         KC_F13,         KC_W,           KC_E,           KC_R,           KC_T,           LCTL(KC_Y),                                     KC_F2,          KC_Y,           KC_U,           KC_I,           KC_O,           KC_F14,         JP_ZKHK,
    KC_Q,           KC_A,           KC_S,           KC_D,           KC_F,           KC_G,                                                                           KC_H,           KC_J,           KC_K,           KC_L,           KC_P,           KC_MINUS,
    KC_LEFT_ALT,    KC_Z,           KC_X,           KC_C,           KC_V,           KC_B,           LCTL(KC_Z),                                     LCTL(KC_S),     KC_N,           KC_M,           KC_COMMA,       KC_DOT,         KC_SLASH,       KC_LEFT_ALT,
    KC_WWW_BACK,    KC_WWW_FORWARD, MO(6),          LM(1,MOD_LCTL), KC_LEFT_CTRL,                                                                                                   KC_RIGHT_SHIFT, LALT(KC_RIGHT_CTRL),LALT(RSFT(KC_LEFT_CTRL)),LGUI(RSFT(KC_LEFT)),LGUI(RSFT(KC_RIGHT)),
                                                                                                    TD(DANCE_1),    KC_LEFT_GUI,    KC_LEFT_GUI,    LGUI(KC_PSCR),
                                                                                                                    TD(DANCE_2),    TD(DANCE_3),
                                                                                    MO(1),          KC_SPACE,       MO(3),          LT(4,KC_ESCAPE),MO(5),          MO(2)
  ),
  [1] = LAYOUT_ergodox_pretty(
    KC_TRANSPARENT, KC_F1,          KC_F2,          KC_F3,          KC_F4,          KC_F5,          KC_F6,                                          KC_F7,          KC_F8,          KC_F9,          KC_F10,         KC_F11,         KC_F12,         KC_TRANSPARENT,
    KC_TRANSPARENT, KC_TRANSPARENT, RSFT(KC_TAB),   KC_UP,          KC_NO,          KC_TAB,         KC_ENTER,                                       LCTL(KC_ENTER), KC_TRANSPARENT, KC_7,           KC_8,           KC_9,           KC_TRANSPARENT, KC_TRANSPARENT,
    KC_TRANSPARENT, KC_TRANSPARENT, KC_LEFT,        KC_DOWN,        KC_RIGHT,       KC_DELETE,                                                                      KC_BSPC,        KC_4,           KC_5,           KC_6,           KC_COMMA,       KC_TRANSPARENT,
    KC_TRANSPARENT, KC_TRANSPARENT, KC_PC_CUT,      KC_PC_COPY,     KC_PC_PASTE,    LCTL(KC_B),     KC_SPACE,                                       RSFT(KC_ENTER), KC_ENTER,       KC_1,           KC_2,           KC_3,           KC_DOT,         KC_TRANSPARENT,
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                                                                                 KC_0,           KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
                                                                                                    KC_COMMA,       KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
                                                                                                                    KC_TRANSPARENT, KC_TRANSPARENT,
                                                                                    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT
  ),
  [2] = LAYOUT_ergodox_pretty(
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
    KC_TRANSPARENT, KC_TRANSPARENT, JP_LPRN,        JP_RPRN,        JP_QUOT,        JP_GRV,         ST_MACRO_0,                                     ST_MACRO_2,     JP_PIPE,        JP_ASTR,        JP_COLN,        JP_AMPR,        JP_CIRC,        KC_TRANSPARENT,
    KC_TRANSPARENT, JP_AT,          JP_LBRC,        JP_RBRC,        JP_DQUO,        JP_PERC,                                                                        JP_EXLM,        JP_PLUS,        JP_SCLN,        JP_HASH,        JP_MINS,        RSFT(JP_CIRC),
    KC_TRANSPARENT, JP_UNDS,        JP_LCBR,        JP_RCBR,        JP_YEN,         JP_DLR,         ST_MACRO_1,                                     ST_MACRO_3,     JP_QUES,        JP_EQL,         JP_LABK,        JP_RABK,        JP_SLSH,        KC_TRANSPARENT,
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                                                                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
                                                                                                    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
                                                                                                                    KC_TRANSPARENT, KC_TRANSPARENT,
                                                                                    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT
  ),
  [3] = LAYOUT_ergodox_pretty(
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_AUDIO_VOL_UP,
    KC_TRANSPARENT, KC_TRANSPARENT, TD(DANCE_4),    KC_MS_UP,       TD(DANCE_5),    KC_NO,          KC_MEDIA_STOP,                                  KC_MEDIA_PLAY_PAUSE,KC_NO,          TD(DANCE_8),    KC_MS_UP,       TD(DANCE_9),    KC_TRANSPARENT, KC_AUDIO_VOL_DOWN,
    KC_TRANSPARENT, TD(DANCE_6),    KC_MS_LEFT,     KC_MS_DOWN,     KC_MS_RIGHT,    TD(DANCE_7),                                                                    TD(DANCE_10),   KC_MS_LEFT,     KC_MS_DOWN,     KC_MS_RIGHT,    TD(DANCE_11),   KC_AUDIO_MUTE,
    KC_TRANSPARENT, KC_NO,          KC_MS_BTN2,     KC_MS_BTN3,     KC_MS_BTN1,     KC_NO,          KC_MEDIA_PREV_TRACK,                                KC_MEDIA_NEXT_TRACK,KC_NO,          KC_MS_BTN1,     KC_MS_BTN3,     KC_MS_BTN2,     KC_NO,          KC_TRANSPARENT,
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                                                                                 KC_AUDIO_VOL_UP,KC_AUDIO_VOL_DOWN,KC_AUDIO_MUTE,  KC_TRANSPARENT, KC_TRANSPARENT,
                                                                                                    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
                                                                                                                    KC_TRANSPARENT, KC_TRANSPARENT,
                                                                                    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT
  ),
  [4] = LAYOUT_ergodox_pretty(
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, LGUI(KC_UP),    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                                                 KC_TRANSPARENT, LGUI(KC_LEFT),  LGUI(KC_DOWN),  LGUI(KC_RIGHT), KC_TRANSPARENT, KC_TRANSPARENT,
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                                                                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
                                                                                                    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
                                                                                                                    KC_TRANSPARENT, KC_TRANSPARENT,
                                                                                    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT
  ),
  [5] = LAYOUT_ergodox_pretty(
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
    KC_TRANSPARENT, KC_HOME,        LCTL(KC_LEFT),  LSFT(RCTL(KC_UP)),LCTL(KC_RIGHT), LCTL(RSFT(KC_I)),KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_TRANSPARENT, RSFT(KC_TAB),   LCTL(KC_SLASH), KC_TAB,         KC_TRANSPARENT, KC_TRANSPARENT,
    KC_TRANSPARENT, RSFT(KC_HOME),  LCTL(RSFT(KC_LEFT)),LSFT(RCTL(KC_DOWN)),LCTL(RSFT(KC_RIGHT)),RSFT(KC_END),                                                                   KC_TRANSPARENT, LCTL(RSFT(KC_TAB)),LALT(RSFT(KC_A)),LCTL(KC_TAB),   KC_TRANSPARENT, KC_TRANSPARENT,
    KC_TRANSPARENT, KC_TRANSPARENT, LSFT(KC_LEFT),  KC_TRANSPARENT, LSFT(KC_RIGHT), KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_TRANSPARENT, ST_MACRO_5,     KC_TRANSPARENT, ST_MACRO_6,     KC_TRANSPARENT, KC_TRANSPARENT,
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, ST_MACRO_4,                                                                                                     KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
                                                                                                    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
                                                                                                                    KC_TRANSPARENT, KC_TRANSPARENT,
                                                                                    KC_TRANSPARENT, KC_LEFT_ALT,    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT
  ),
  [6] = LAYOUT_ergodox_pretty(
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_7,           KC_8,           KC_9,           KC_TRANSPARENT, KC_TRANSPARENT,
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                                                 KC_TRANSPARENT, KC_4,           KC_5,           KC_6,           KC_TRANSPARENT, KC_TRANSPARENT,
    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                 KC_TRANSPARENT, KC_TRANSPARENT, KC_1,           KC_2,           KC_3,           KC_TRANSPARENT, KC_TRANSPARENT,
    KC_ESCAPE,      KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,                                                                                                 KC_0,           KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
                                                                                                    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT,
                                                                                                                    KC_TRANSPARENT, KC_TRANSPARENT,
                                                                                    KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_TRANSPARENT, KC_LEFT_GUI
  ),
};




bool process_record_user(uint16_t keycode, keyrecord_t *record) {
  switch (keycode) {
    case ST_MACRO_0:
    if (record->event.pressed) {
      SEND_STRING(SS_TAP(X_Z) SS_DELAY(100) SS_TAP(X_J) SS_DELAY(100) SS_TAP(X_SPACE)  SS_DELAY(100) SS_TAP(X_ENTER));
    }
    break;
    case ST_MACRO_1:
    if (record->event.pressed) {
      SEND_STRING(SS_TAP(X_Z) SS_DELAY(100) SS_TAP(X_H) SS_DELAY(100) SS_TAP(X_SPACE)  SS_DELAY(100) SS_TAP(X_ENTER));
    }
    break;
    case ST_MACRO_2:
    if (record->event.pressed) {
      SEND_STRING(SS_TAP(X_Z) SS_DELAY(100) SS_TAP(X_K) SS_DELAY(100) SS_TAP(X_SPACE)  SS_DELAY(100) SS_TAP(X_ENTER));
    }
    break;
    case ST_MACRO_3:
    if (record->event.pressed) {
      SEND_STRING(SS_TAP(X_Z) SS_DELAY(100) SS_TAP(X_L) SS_DELAY(100) SS_TAP(X_SPACE)  SS_DELAY(100) SS_TAP(X_ENTER));
    }
    break;
    case ST_MACRO_4:
    if (record->event.pressed) {
      SEND_STRING(SS_LALT(SS_TAP(X_SPACE)) SS_DELAY(100) SS_TAP(X_N));
    }
    break;
    case ST_MACRO_5:
    if (record->event.pressed) {
      SEND_STRING(SS_LALT(SS_TAP(X_TAB) ));
    }
    break;
    case ST_MACRO_6:
    if (record->event.pressed) {
      SEND_STRING(SS_LALT(SS_TAP(X_TAB) ));
    }
    break;

  }
  return true;
}

uint8_t layer_state_set_user(uint8_t state) {
    uint8_t layer = biton(state);
  ergodox_board_led_off();
  ergodox_right_led_1_off();
  ergodox_right_led_2_off();
  ergodox_right_led_3_off();
  switch (layer) {
    case 1:
      ergodox_right_led_1_on();
      break;
    case 2:
      ergodox_right_led_2_on();
      break;
    case 3:
      ergodox_right_led_3_on();
      break;
    case 4:
      ergodox_right_led_1_on();
      ergodox_right_led_2_on();
      break;
    case 5:
      ergodox_right_led_1_on();
      ergodox_right_led_3_on();
      break;
    case 6:
      ergodox_right_led_2_on();
      ergodox_right_led_3_on();
      break;
    case 7:
      ergodox_right_led_1_on();
      ergodox_right_led_2_on();
      ergodox_right_led_3_on();
      break;
    default:
      break;
  }
  return state;
};


typedef struct {
    bool is_press_action;
    uint8_t step;
} tap;

enum {
    SINGLE_TAP = 1,
    SINGLE_HOLD,
    DOUBLE_TAP,
    DOUBLE_HOLD,
    DOUBLE_SINGLE_TAP,
    MORE_TAPS
};

static tap dance_state[12];

uint8_t dance_step(tap_dance_state_t *state);

uint8_t dance_step(tap_dance_state_t *state) {
    if (state->count == 1) {
        if (state->interrupted || !state->pressed) return SINGLE_TAP;
        else return SINGLE_HOLD;
    } else if (state->count == 2) {
        if (state->interrupted) return DOUBLE_SINGLE_TAP;
        else if (state->pressed) return DOUBLE_HOLD;
        else return DOUBLE_TAP;
    }
    return MORE_TAPS;
}


void on_dance_0(tap_dance_state_t *state, void *user_data);
void dance_0_finished(tap_dance_state_t *state, void *user_data);
void dance_0_reset(tap_dance_state_t *state, void *user_data);

void on_dance_0(tap_dance_state_t *state, void *user_data) {
    if(state->count == 3) {
        tap_code16(LCTL(KC_W));
        tap_code16(LCTL(KC_W));
        tap_code16(LCTL(KC_W));
    }
    if(state->count > 3) {
        tap_code16(LCTL(KC_W));
    }
}

void dance_0_finished(tap_dance_state_t *state, void *user_data) {
    dance_state[0].step = dance_step(state);
    switch (dance_state[0].step) {
        case SINGLE_TAP: register_code16(LCTL(KC_W)); break;
        case SINGLE_HOLD: register_code16(LALT(KC_F4)); break;
        case DOUBLE_TAP: register_code16(LCTL(KC_W)); register_code16(LCTL(KC_W)); break;
        case DOUBLE_SINGLE_TAP: tap_code16(LCTL(KC_W)); register_code16(LCTL(KC_W));
    }
}

void dance_0_reset(tap_dance_state_t *state, void *user_data) {
    wait_ms(10);
    switch (dance_state[0].step) {
        case SINGLE_TAP: unregister_code16(LCTL(KC_W)); break;
        case SINGLE_HOLD: unregister_code16(LALT(KC_F4)); break;
        case DOUBLE_TAP: unregister_code16(LCTL(KC_W)); break;
        case DOUBLE_SINGLE_TAP: unregister_code16(LCTL(KC_W)); break;
    }
    dance_state[0].step = 0;
}
void on_dance_1(tap_dance_state_t *state, void *user_data);
void dance_1_finished(tap_dance_state_t *state, void *user_data);
void dance_1_reset(tap_dance_state_t *state, void *user_data);

void on_dance_1(tap_dance_state_t *state, void *user_data) {
    if(state->count == 3) {
        tap_code16(LCTL(KC_TAB));
        tap_code16(LCTL(KC_TAB));
        tap_code16(LCTL(KC_TAB));
    }
    if(state->count > 3) {
        tap_code16(LCTL(KC_TAB));
    }
}

void dance_1_finished(tap_dance_state_t *state, void *user_data) {
    dance_state[1].step = dance_step(state);
    switch (dance_state[1].step) {
        case SINGLE_TAP: register_code16(LCTL(KC_TAB)); break;
        case SINGLE_HOLD: register_code16(LCTL(RSFT(KC_TAB))); break;
        case DOUBLE_TAP: register_code16(LCTL(KC_TAB)); register_code16(LCTL(KC_TAB)); break;
        case DOUBLE_SINGLE_TAP: tap_code16(LCTL(KC_TAB)); register_code16(LCTL(KC_TAB));
    }
}

void dance_1_reset(tap_dance_state_t *state, void *user_data) {
    wait_ms(10);
    switch (dance_state[1].step) {
        case SINGLE_TAP: unregister_code16(LCTL(KC_TAB)); break;
        case SINGLE_HOLD: unregister_code16(LCTL(RSFT(KC_TAB))); break;
        case DOUBLE_TAP: unregister_code16(LCTL(KC_TAB)); break;
        case DOUBLE_SINGLE_TAP: unregister_code16(LCTL(KC_TAB)); break;
    }
    dance_state[1].step = 0;
}
void dance_2_finished(tap_dance_state_t *state, void *user_data);
void dance_2_reset(tap_dance_state_t *state, void *user_data);

void dance_2_finished(tap_dance_state_t *state, void *user_data) {
    dance_state[2].step = dance_step(state);
    switch (dance_state[2].step) {
        case DOUBLE_HOLD: register_code16(KC_SYSTEM_SLEEP); break;
    }
}

void dance_2_reset(tap_dance_state_t *state, void *user_data) {
    wait_ms(10);
    switch (dance_state[2].step) {
        case DOUBLE_HOLD: unregister_code16(KC_SYSTEM_SLEEP); break;
    }
    dance_state[2].step = 0;
}
void dance_3_finished(tap_dance_state_t *state, void *user_data);
void dance_3_reset(tap_dance_state_t *state, void *user_data);

void dance_3_finished(tap_dance_state_t *state, void *user_data) {
    dance_state[3].step = dance_step(state);
    switch (dance_state[3].step) {
        case DOUBLE_HOLD: register_code16(LGUI(KC_ESCAPE)); break;
    }
}

void dance_3_reset(tap_dance_state_t *state, void *user_data) {
    wait_ms(10);
    switch (dance_state[3].step) {
        case DOUBLE_HOLD: unregister_code16(LGUI(KC_ESCAPE)); break;
    }
    dance_state[3].step = 0;
}
void on_dance_4(tap_dance_state_t *state, void *user_data);
void dance_4_finished(tap_dance_state_t *state, void *user_data);
void dance_4_reset(tap_dance_state_t *state, void *user_data);

void on_dance_4(tap_dance_state_t *state, void *user_data) {
    if(state->count == 3) {
        tap_code16(KC_MS_WH_DOWN);
        tap_code16(KC_MS_WH_DOWN);
        tap_code16(KC_MS_WH_DOWN);
    }
    if(state->count > 3) {
        tap_code16(KC_MS_WH_DOWN);
    }
}

void dance_4_finished(tap_dance_state_t *state, void *user_data) {
    dance_state[4].step = dance_step(state);
    switch (dance_state[4].step) {
        case SINGLE_TAP: register_code16(KC_MS_WH_DOWN); break;
        case SINGLE_HOLD: register_code16(KC_MS_WH_DOWN); break;
        case DOUBLE_TAP: register_code16(KC_MS_WH_DOWN); register_code16(KC_MS_WH_DOWN); break;
        case DOUBLE_SINGLE_TAP: tap_code16(KC_MS_WH_DOWN); register_code16(KC_MS_WH_DOWN);
    }
}

void dance_4_reset(tap_dance_state_t *state, void *user_data) {
    wait_ms(10);
    switch (dance_state[4].step) {
        case SINGLE_TAP: unregister_code16(KC_MS_WH_DOWN); break;
        case SINGLE_HOLD: unregister_code16(KC_MS_WH_DOWN); break;
        case DOUBLE_TAP: unregister_code16(KC_MS_WH_DOWN); break;
        case DOUBLE_SINGLE_TAP: unregister_code16(KC_MS_WH_DOWN); break;
    }
    dance_state[4].step = 0;
}
void on_dance_5(tap_dance_state_t *state, void *user_data);
void dance_5_finished(tap_dance_state_t *state, void *user_data);
void dance_5_reset(tap_dance_state_t *state, void *user_data);

void on_dance_5(tap_dance_state_t *state, void *user_data) {
    if(state->count == 3) {
        tap_code16(KC_MS_WH_UP);
        tap_code16(KC_MS_WH_UP);
        tap_code16(KC_MS_WH_UP);
    }
    if(state->count > 3) {
        tap_code16(KC_MS_WH_UP);
    }
}

void dance_5_finished(tap_dance_state_t *state, void *user_data) {
    dance_state[5].step = dance_step(state);
    switch (dance_state[5].step) {
        case SINGLE_TAP: register_code16(KC_MS_WH_UP); break;
        case SINGLE_HOLD: register_code16(KC_MS_WH_UP); break;
        case DOUBLE_TAP: register_code16(KC_MS_WH_UP); register_code16(KC_MS_WH_UP); break;
        case DOUBLE_SINGLE_TAP: tap_code16(KC_MS_WH_UP); register_code16(KC_MS_WH_UP);
    }
}

void dance_5_reset(tap_dance_state_t *state, void *user_data) {
    wait_ms(10);
    switch (dance_state[5].step) {
        case SINGLE_TAP: unregister_code16(KC_MS_WH_UP); break;
        case SINGLE_HOLD: unregister_code16(KC_MS_WH_UP); break;
        case DOUBLE_TAP: unregister_code16(KC_MS_WH_UP); break;
        case DOUBLE_SINGLE_TAP: unregister_code16(KC_MS_WH_UP); break;
    }
    dance_state[5].step = 0;
}
void on_dance_6(tap_dance_state_t *state, void *user_data);
void dance_6_finished(tap_dance_state_t *state, void *user_data);
void dance_6_reset(tap_dance_state_t *state, void *user_data);

void on_dance_6(tap_dance_state_t *state, void *user_data) {
    if(state->count == 3) {
        tap_code16(KC_MS_WH_LEFT);
        tap_code16(KC_MS_WH_LEFT);
        tap_code16(KC_MS_WH_LEFT);
    }
    if(state->count > 3) {
        tap_code16(KC_MS_WH_LEFT);
    }
}

void dance_6_finished(tap_dance_state_t *state, void *user_data) {
    dance_state[6].step = dance_step(state);
    switch (dance_state[6].step) {
        case SINGLE_TAP: register_code16(KC_MS_WH_LEFT); break;
        case SINGLE_HOLD: register_code16(KC_MS_WH_LEFT); break;
        case DOUBLE_TAP: register_code16(KC_MS_WH_LEFT); register_code16(KC_MS_WH_LEFT); break;
        case DOUBLE_SINGLE_TAP: tap_code16(KC_MS_WH_LEFT); register_code16(KC_MS_WH_LEFT);
    }
}

void dance_6_reset(tap_dance_state_t *state, void *user_data) {
    wait_ms(10);
    switch (dance_state[6].step) {
        case SINGLE_TAP: unregister_code16(KC_MS_WH_LEFT); break;
        case SINGLE_HOLD: unregister_code16(KC_MS_WH_LEFT); break;
        case DOUBLE_TAP: unregister_code16(KC_MS_WH_LEFT); break;
        case DOUBLE_SINGLE_TAP: unregister_code16(KC_MS_WH_LEFT); break;
    }
    dance_state[6].step = 0;
}
void on_dance_7(tap_dance_state_t *state, void *user_data);
void dance_7_finished(tap_dance_state_t *state, void *user_data);
void dance_7_reset(tap_dance_state_t *state, void *user_data);

void on_dance_7(tap_dance_state_t *state, void *user_data) {
    if(state->count == 3) {
        tap_code16(KC_MS_WH_RIGHT);
        tap_code16(KC_MS_WH_RIGHT);
        tap_code16(KC_MS_WH_RIGHT);
    }
    if(state->count > 3) {
        tap_code16(KC_MS_WH_RIGHT);
    }
}

void dance_7_finished(tap_dance_state_t *state, void *user_data) {
    dance_state[7].step = dance_step(state);
    switch (dance_state[7].step) {
        case SINGLE_TAP: register_code16(KC_MS_WH_RIGHT); break;
        case SINGLE_HOLD: register_code16(KC_MS_WH_RIGHT); break;
        case DOUBLE_TAP: register_code16(KC_MS_WH_RIGHT); register_code16(KC_MS_WH_RIGHT); break;
        case DOUBLE_SINGLE_TAP: tap_code16(KC_MS_WH_RIGHT); register_code16(KC_MS_WH_RIGHT);
    }
}

void dance_7_reset(tap_dance_state_t *state, void *user_data) {
    wait_ms(10);
    switch (dance_state[7].step) {
        case SINGLE_TAP: unregister_code16(KC_MS_WH_RIGHT); break;
        case SINGLE_HOLD: unregister_code16(KC_MS_WH_RIGHT); break;
        case DOUBLE_TAP: unregister_code16(KC_MS_WH_RIGHT); break;
        case DOUBLE_SINGLE_TAP: unregister_code16(KC_MS_WH_RIGHT); break;
    }
    dance_state[7].step = 0;
}
void on_dance_8(tap_dance_state_t *state, void *user_data);
void dance_8_finished(tap_dance_state_t *state, void *user_data);
void dance_8_reset(tap_dance_state_t *state, void *user_data);

void on_dance_8(tap_dance_state_t *state, void *user_data) {
    if(state->count == 3) {
        tap_code16(KC_MS_WH_UP);
        tap_code16(KC_MS_WH_UP);
        tap_code16(KC_MS_WH_UP);
    }
    if(state->count > 3) {
        tap_code16(KC_MS_WH_UP);
    }
}

void dance_8_finished(tap_dance_state_t *state, void *user_data) {
    dance_state[8].step = dance_step(state);
    switch (dance_state[8].step) {
        case SINGLE_TAP: register_code16(KC_MS_WH_UP); break;
        case SINGLE_HOLD: register_code16(KC_MS_WH_UP); break;
        case DOUBLE_TAP: register_code16(KC_MS_WH_UP); register_code16(KC_MS_WH_UP); break;
        case DOUBLE_SINGLE_TAP: tap_code16(KC_MS_WH_UP); register_code16(KC_MS_WH_UP);
    }
}

void dance_8_reset(tap_dance_state_t *state, void *user_data) {
    wait_ms(10);
    switch (dance_state[8].step) {
        case SINGLE_TAP: unregister_code16(KC_MS_WH_UP); break;
        case SINGLE_HOLD: unregister_code16(KC_MS_WH_UP); break;
        case DOUBLE_TAP: unregister_code16(KC_MS_WH_UP); break;
        case DOUBLE_SINGLE_TAP: unregister_code16(KC_MS_WH_UP); break;
    }
    dance_state[8].step = 0;
}
void on_dance_9(tap_dance_state_t *state, void *user_data);
void dance_9_finished(tap_dance_state_t *state, void *user_data);
void dance_9_reset(tap_dance_state_t *state, void *user_data);

void on_dance_9(tap_dance_state_t *state, void *user_data) {
    if(state->count == 3) {
        tap_code16(KC_MS_WH_DOWN);
        tap_code16(KC_MS_WH_DOWN);
        tap_code16(KC_MS_WH_DOWN);
    }
    if(state->count > 3) {
        tap_code16(KC_MS_WH_DOWN);
    }
}

void dance_9_finished(tap_dance_state_t *state, void *user_data) {
    dance_state[9].step = dance_step(state);
    switch (dance_state[9].step) {
        case SINGLE_TAP: register_code16(KC_MS_WH_DOWN); break;
        case SINGLE_HOLD: register_code16(KC_MS_WH_DOWN); break;
        case DOUBLE_TAP: register_code16(KC_MS_WH_DOWN); register_code16(KC_MS_WH_DOWN); break;
        case DOUBLE_SINGLE_TAP: tap_code16(KC_MS_WH_DOWN); register_code16(KC_MS_WH_DOWN);
    }
}

void dance_9_reset(tap_dance_state_t *state, void *user_data) {
    wait_ms(10);
    switch (dance_state[9].step) {
        case SINGLE_TAP: unregister_code16(KC_MS_WH_DOWN); break;
        case SINGLE_HOLD: unregister_code16(KC_MS_WH_DOWN); break;
        case DOUBLE_TAP: unregister_code16(KC_MS_WH_DOWN); break;
        case DOUBLE_SINGLE_TAP: unregister_code16(KC_MS_WH_DOWN); break;
    }
    dance_state[9].step = 0;
}
void on_dance_10(tap_dance_state_t *state, void *user_data);
void dance_10_finished(tap_dance_state_t *state, void *user_data);
void dance_10_reset(tap_dance_state_t *state, void *user_data);

void on_dance_10(tap_dance_state_t *state, void *user_data) {
    if(state->count == 3) {
        tap_code16(KC_MS_WH_LEFT);
        tap_code16(KC_MS_WH_LEFT);
        tap_code16(KC_MS_WH_LEFT);
    }
    if(state->count > 3) {
        tap_code16(KC_MS_WH_LEFT);
    }
}

void dance_10_finished(tap_dance_state_t *state, void *user_data) {
    dance_state[10].step = dance_step(state);
    switch (dance_state[10].step) {
        case SINGLE_TAP: register_code16(KC_MS_WH_LEFT); break;
        case SINGLE_HOLD: register_code16(KC_MS_WH_LEFT); break;
        case DOUBLE_TAP: register_code16(KC_MS_WH_LEFT); register_code16(KC_MS_WH_LEFT); break;
        case DOUBLE_SINGLE_TAP: tap_code16(KC_MS_WH_LEFT); register_code16(KC_MS_WH_LEFT);
    }
}

void dance_10_reset(tap_dance_state_t *state, void *user_data) {
    wait_ms(10);
    switch (dance_state[10].step) {
        case SINGLE_TAP: unregister_code16(KC_MS_WH_LEFT); break;
        case SINGLE_HOLD: unregister_code16(KC_MS_WH_LEFT); break;
        case DOUBLE_TAP: unregister_code16(KC_MS_WH_LEFT); break;
        case DOUBLE_SINGLE_TAP: unregister_code16(KC_MS_WH_LEFT); break;
    }
    dance_state[10].step = 0;
}
void on_dance_11(tap_dance_state_t *state, void *user_data);
void dance_11_finished(tap_dance_state_t *state, void *user_data);
void dance_11_reset(tap_dance_state_t *state, void *user_data);

void on_dance_11(tap_dance_state_t *state, void *user_data) {
    if(state->count == 3) {
        tap_code16(KC_MS_WH_RIGHT);
        tap_code16(KC_MS_WH_RIGHT);
        tap_code16(KC_MS_WH_RIGHT);
    }
    if(state->count > 3) {
        tap_code16(KC_MS_WH_RIGHT);
    }
}

void dance_11_finished(tap_dance_state_t *state, void *user_data) {
    dance_state[11].step = dance_step(state);
    switch (dance_state[11].step) {
        case SINGLE_TAP: register_code16(KC_MS_WH_RIGHT); break;
        case SINGLE_HOLD: register_code16(KC_MS_WH_RIGHT); break;
        case DOUBLE_TAP: register_code16(KC_MS_WH_RIGHT); register_code16(KC_MS_WH_RIGHT); break;
        case DOUBLE_SINGLE_TAP: tap_code16(KC_MS_WH_RIGHT); register_code16(KC_MS_WH_RIGHT);
    }
}

void dance_11_reset(tap_dance_state_t *state, void *user_data) {
    wait_ms(10);
    switch (dance_state[11].step) {
        case SINGLE_TAP: unregister_code16(KC_MS_WH_RIGHT); break;
        case SINGLE_HOLD: unregister_code16(KC_MS_WH_RIGHT); break;
        case DOUBLE_TAP: unregister_code16(KC_MS_WH_RIGHT); break;
        case DOUBLE_SINGLE_TAP: unregister_code16(KC_MS_WH_RIGHT); break;
    }
    dance_state[11].step = 0;
}

tap_dance_action_t tap_dance_actions[] = {
        [DANCE_0] = ACTION_TAP_DANCE_FN_ADVANCED(on_dance_0, dance_0_finished, dance_0_reset),
        [DANCE_1] = ACTION_TAP_DANCE_FN_ADVANCED(on_dance_1, dance_1_finished, dance_1_reset),
        [DANCE_2] = ACTION_TAP_DANCE_FN_ADVANCED(NULL, dance_2_finished, dance_2_reset),
        [DANCE_3] = ACTION_TAP_DANCE_FN_ADVANCED(NULL, dance_3_finished, dance_3_reset),
        [DANCE_4] = ACTION_TAP_DANCE_FN_ADVANCED(on_dance_4, dance_4_finished, dance_4_reset),
        [DANCE_5] = ACTION_TAP_DANCE_FN_ADVANCED(on_dance_5, dance_5_finished, dance_5_reset),
        [DANCE_6] = ACTION_TAP_DANCE_FN_ADVANCED(on_dance_6, dance_6_finished, dance_6_reset),
        [DANCE_7] = ACTION_TAP_DANCE_FN_ADVANCED(on_dance_7, dance_7_finished, dance_7_reset),
        [DANCE_8] = ACTION_TAP_DANCE_FN_ADVANCED(on_dance_8, dance_8_finished, dance_8_reset),
        [DANCE_9] = ACTION_TAP_DANCE_FN_ADVANCED(on_dance_9, dance_9_finished, dance_9_reset),
        [DANCE_10] = ACTION_TAP_DANCE_FN_ADVANCED(on_dance_10, dance_10_finished, dance_10_reset),
        [DANCE_11] = ACTION_TAP_DANCE_FN_ADVANCED(on_dance_11, dance_11_finished, dance_11_reset),
};
