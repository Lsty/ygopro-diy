--神天龙-震龙
function c9991205.initial_effect(c)
	--Special Summon From Hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9991205,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP_DEFENCE,0)
	e1:SetValue(0x40000fff)
	e1:SetCondition(c9991205.spcon)
	e1:SetOperation(c9991205.spop)
	c:RegisterEffect(e1)
	--To Hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9991205,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,9991205)
	e2:SetCondition(c9991205.con1)
	e2:SetTarget(c9991205.tg1)
	e2:SetOperation(c9991205.op1)
	c:RegisterEffect(e2)
	--Draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9991205,2))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCountLimit(1,9991205)
	e3:SetCondition(c9991205.con2)
	e3:SetTarget(c9991205.tg2)
	e3:SetOperation(c9991205.op2)
	c:RegisterEffect(e3)
	--Xyz Limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e4:SetCondition(c9991205.xlcon)
	e4:SetValue(aux.TRUE)
	c:RegisterEffect(e4)
end
function c9991205.spfilter(c)
	return c:IsRace(RACE_WYRM) and c:IsAbleToGraveAsCost()
end
function c9991205.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9991205.spfilter,tp,LOCATION_HAND,0,1,c)
end
function c9991205.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9991205.spfilter,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST)
end
function c9991205.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c9991205.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==0x40000fff
end
function c9991205.thfilter(c)
	return c:IsSetCard(0x46) and c:IsAbleToHand()
end
function c9991205.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9991205.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c9991205.op1(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c9991205.thfilter,tp,LOCATION_GRAVE,0,nil)
	if sg and sg:GetCount()~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local rg=sg:Select(tp,1,1,nil)
		Duel.HintSelection(rg)
		Duel.SendtoHand(rg,nil,REASON_EFFECT)
	end
end
function c9991205.con2(e,tp,eg,ep,ev,re,r,rp)
	return ( not e:GetHandler():IsLocation(LOCATION_DECK) ) and r==REASON_FUSION and e:GetHandler():GetReasonCard():IsSetCard(0xfff)
end
function c9991205.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c9991205.op2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c9991205.xlcon(e,c)
	return e:GetHandler():IsDefencePos()
end
