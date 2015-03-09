--魔物猎人 看板娘
function c6667001.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,6667001)
	e1:SetCondition(c6667001.spcon)
	c:RegisterEffect(e1)
	--mission start
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,6657001)
	e2:SetCost(c6667001.cost)
	e2:SetTarget(c6667001.target)
	e2:SetOperation(c6667001.activate)
	c:RegisterEffect(e2)
	--cannot be battle target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetCondition(c6667001.atkcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--control
	local e99=Effect.CreateEffect(c)
	e99:SetType(EFFECT_TYPE_SINGLE)
	e99:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e99:SetRange(LOCATION_MZONE)
	e99:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	c:RegisterEffect(e99)
end
function c6667001.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x790)
end
function c6667001.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c6667001.filter1,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c6667001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,3) end
	Duel.DiscardDeck(tp,3,REASON_COST)
end
function c6667001.filter(c)
	return c:IsSetCard(0x790) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c6667001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6667001.filter,tp,LOCATION_DECK,0,1,nil) end
	local ac=math.random(6667201,6667206) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
	e:SetLabel(ac)
end
function c6667001.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c6667001.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local token=Duel.CreateToken(tp,e:GetLabel())
	Duel.MoveToField(token,tp,1-tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
end
function c6667001.atkcon(e)
	return Duel.IsExistingMatchingCard(c6667001.filter1,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end