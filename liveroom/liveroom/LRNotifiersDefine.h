//
//  LRNotifiersDefine.h
//  Tigercrew
//
//  Created by 杜洁鹏 on 2019/3/26.
//  Copyright © 2019 Easemob. All rights reserved.
//

#ifndef LRNotifiersDefine_h
#define LRNotifiersDefine_h

//账号状态
#define LR_ACCOUNT_LOGIN_CHANGED @"loginStateChange"
#define LR_NOTIFICATION_ROOM_LIST_DIDCHANGEED @"RoomListDidChanged"

//狼人杀模式当前房间时钟状态
#define LR_CLOCK_STATE_CHANGE @"ClockStateChange"

//狼人杀模式夜晚狼人下麦
#define LR_OFFLINE_ON_NIGHT @"OfflineOnNight"

//狼人数组已改变
#define LR_WEREWOLF_DIDCHANGE @"WerewolfDidChange"

//添加狼人进狼人数组
#define LR_ADD_WEREWOLF_ARRY @"addWerewolfArry"

// Conference
#define LR_Receive_OnSpeak_Request_Notification         @"ReceiveOnSpeakApply"
#define LR_Receive_OnSpeak_Reject_Notification          @"ReceiveOnSpeakReject"
#define LR_Receive_ToBe_Audience_Notification           @"ReceiveToByAudience"

#define LR_Receive_Conference_Destory_Notification        @"ReceiveConferenceDestory"


#define LR_UI_ChangeRoleToSpeaker_Notification          @"ChangeRoleToSpeaker"
#define LR_UI_ChangeRoleToAudience_Notification         @"ChangeRoleToAudience"

#define LR_Stream_Did_Speaking_Notification             @"StreamDidSpeaking"
#define LR_Remain_Speaking_timer_Notification             @"speakingTimer"
#define LR_Un_Argument_Speaker_Notification             @"unArgumentSpeaker"
#define LR_User_To_Speaker_Notification                     @"userToSpeaker"

// account
#define LR_Did_Login_Other_Device_Notification             @"didLoginOtherDevice"

#define LR_Exit_Chatroom_Notification             @"exitChatroom"
#define LR_Join_Conference_Password_Error_Notification             @"joinConferencePasswordError"
#define LR_LikeAndGift_Button_Action_Notification             @"likeAndGiftButtonAction"
#define LR_ChatView_Tableview_Roll_Notification             @"chatTableviewRoll"
#define LR_Send_Messages_Notification             @"chatViewSendMessage"
#define LR_KickedOut_Chatroom_Notification             @"kickedOutChatroomMessage"

#endif /* LRNotifiersDefine_h */
