--地之记忆 比那名居天子
function c6668627.initial_effect(c)
		c:SetUniqueOnField(1,0,6668627)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,6668614,c6668627.ffilter,1,true,true)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(6668627,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c6668627.target)
	e1:SetOperation(c6668627.operation)
	c:RegisterEffect(e1)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(6668627,1))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c6668627.thtg)
	e3:SetOperation(c6668627.thop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetCondition(c6668627.condition)
	e4:SetCode(EFFECT_SKIP_M1)
	c:RegisterEffect(e4)
	--atk up
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(0,LOCATION_MZONE)
	e6:SetValue(c6668627.val1)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_UPDATE_DEFENCE)
	c:RegisterEffect(e7)
end
function c6668627.ffilter(c)
	return c:IsSetCard(0x740) and c:IsType(TYPE_XYZ)
end
function c6668627.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c6668627.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c6668627.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c6668627.filter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c6668627.filter,tp,LOCATION_ONFIELD,0,1,11,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c6668627.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local rg=tg:Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoHand(rg,nil,REASON_EFFECT)
end
function c6668627.tgfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x740) and c:IsType(TYPE_MONSTER)) or c:IsSetCard(0x741)
end
function c6668627.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c6668627.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c6668627.tgfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c6668627.tgfilter,tp,LOCATION_REMOVED,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,2,0,0)
end
function c6668627.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)
	end
end
function c6668627.spfilter(c)
	return c:IsSetCard(0x741) and c:IsType(TYPE_SPELL+TYPE_CONTINUOUS) and c:IsFaceup() and c:GetSequence()<6
end
function c6668627.condition(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c6668627.spfilter,e:GetHandlerPlayer(),LOCATION_SZONE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>=3
end
function c6668627.filter1(c)
	return c:IsSetCard(0x741) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup() and c:GetSequence()<6
end
function c6668627.val1(e,c)
	return Duel.GetMatchingGroupCount(c6668627.filter1,e:GetHandlerPlayer(),LOCATION_SZONE,0,nil)*-300
end