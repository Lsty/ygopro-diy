--虹纹骑士-蓝水
function c999999790.initial_effect(c)
	--①
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1050186,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,999999790)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(c999999790.target)
	e1:SetOperation(c999999790.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--②
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1050186,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,999999790)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCost(c999999790.cost)
	e3:SetTarget(c999999790.target)
	e3:SetOperation(c999999790.operation)
	c:RegisterEffect(e3)
     --自己场上有这张卡以外的「虹纹」怪兽存在的场合，这张卡当做调整使用。
	 local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_CHANGE_TYPE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_PLAYER_TARGET)
    e4:SetRange(LOCATION_MZONE)
    e4:SetValue(c999999790.change)
    c:RegisterEffect(e4)
end
function c999999790.change(e,c)
    if c:IsFaceup() and not c:IsSetCard(0xf70) then return TYPE_MONSTER
    else return TYPE_MONSTER+TYPE_TUNER end
end
function c999999790.cffilter(c)
	return c:IsSetCard(0xf70) and not c:IsPublic()
end
function c999999790.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,999999790)==0
	and Duel.IsExistingMatchingCard(c999999790.cffilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c999999790.cffilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	Duel.RegisterFlagEffect(tp,999999790,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c999999790.filter(c)
	return c:IsSetCard(0xf70) and c:IsAbleToRemove()
end
function c999999790.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999999790.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c999999790.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c999999790.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tg=g:GetFirst()
	if tg==nil then return false end
	Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
end