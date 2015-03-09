--救济之神-圆环之理
function c9991010.initial_effect(c)
	--Summon Rule
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c9991010.xyzcon)
	e1:SetOperation(c9991010.xyzop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(aux.FALSE)
	c:RegisterEffect(e3)
	--Arrow of Rule
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9991010,0))
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetHintTiming(0,0x1c0)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,9991010)
	e4:SetTarget(c9991010.target1)
	e4:SetOperation(c9991010.operation1)
	c:RegisterEffect(e4)
	--Salvation of Goddess
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(9991010,1))
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BATTLE_START)
	e5:SetCountLimit(1,99910102)
	e5:SetTarget(c9991010.target2)
	e5:SetOperation(c9991010.operation2)
	c:RegisterEffect(e5)
	--Destruction Immunity
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e7)
end
function c9991010.xyzfilter(c)
	return c:IsSetCard(0xeff) and c:IsType(TYPE_SYNCHRO) and c:IsFaceup()
end
function c9991010.xyzcon(e,c,og)
	if c==nil then return true end local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 and Duel.GetMatchingGroupCount(c9991010.xyzfilter,tp,LOCATION_MZONE,0,nil)>=3
end
function c9991010.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c9991010.xyzfilter,tp,LOCATION_MZONE,0,3,3,nil)
	Duel.Overlay(c,g)
end
function c9991010.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c9991010.operation1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAIN_ACTIVATING)
	e1:SetCountLimit(1)
	e1:SetCondition(c9991010.discon)
	e1:SetOperation(c9991010.disop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9991010.discon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.IsChainNegatable(ev)
end
function c9991010.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
function c9991010.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetBattleTarget() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler():GetBattleTarget(),1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c9991010.operation2(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetHandler():GetBattleTarget():GetCode()
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,0,0x5f,nil,code)
	Duel.Remove(g,POS_FACEUP,REASON_RULE)
	local hand=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local field=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD):Filter(Card.IsFacedown,nil)
	local deck=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	local extra=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA):Filter(c9991010.filter,nil)
	if hand:GetCount()~=0 then Duel.ConfirmCards(tp,hand) Duel.ShuffleHand(1-tp) end
	if field:GetCount()~=0 then Duel.ConfirmCards(tp,field) Duel.ShuffleSetCard(field) end
	if deck:GetCount()~=0 then Duel.ConfirmCards(tp,deck) Duel.ShuffleDeck(1-tp) end
	if extra:GetCount()~=0 then Duel.ConfirmCards(tp,extra) end
	local extra=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	local tc=extra:GetFirst() while tc do tc:RegisterFlagEffect(9991010,RESET_EVENT+0x1fe0000,0,1) tc=extra:GetNext() end
end
function c9991010.filter(c)
	return c:GetFlagEffect(9991010)==0 and c:IsFacedown()
end
