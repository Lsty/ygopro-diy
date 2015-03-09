--厄运神明 键山雏
function c13130030.initial_effect(c)
	c:SetUniqueOnField(1,0,13130030)
	c:EnableReviveLimit()
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(c13130030.spcon)
	e0:SetOperation(c13130030.spop)
	c:RegisterEffect(e0)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13130010,1))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetCondition(c13130030.thcon)
	e1:SetCost(c13130030.thcost)
	e1:SetTarget(c13130030.thtg)
	e1:SetOperation(c13130030.thop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c13130030.reptg)
	e2:SetValue(c13130030.repval)
	e2:SetOperation(c13130030.repop)
	c:RegisterEffect(e2)
	--battle indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	e3:SetCondition(c13130030.effcon2)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(c13130030.efilter3)
	e4:SetCondition(c13130030.effcon3)
	c:RegisterEffect(e4)
	--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetValue(c13130030.efilter4)
	e5:SetCondition(c13130030.effcon4)
	c:RegisterEffect(e5)
	--half damage
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e6:SetCondition(c13130030.rdcon)
	e6:SetOperation(c13130030.rdop)
	c:RegisterEffect(e6)
end
function c13130030.filter(c)
	return c:IsType(TYPE_TRAP) and c:IsFaceup()
end
function c13130030.spfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function c13130030.spcon(e,c)
	if c==nil then return true end
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)==0 then
		return Duel.IsExistingMatchingCard(c13130030.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
			and Duel.IsExistingMatchingCard(c13130030.spfilter,c:GetControler(),LOCATION_ONFIELD,0,3,nil)
	else
		return Duel.IsExistingMatchingCard(c13130030.spfilter,c:GetControler(),LOCATION_ONFIELD,0,3,nil)
	end
end
function c13130030.spop(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g1=Duel.SelectMatchingCard(tp,c13130030.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g2=Duel.SelectMatchingCard(tp,c13130030.spfilter,tp,LOCATION_ONFIELD,0,2,2,g1:GetFirst())
		g2:AddCard(g1:GetFirst())
		Duel.SendtoGrave(g2,REASON_COST)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c13130030.spfilter,tp,LOCATION_ONFIELD,0,3,3,nil)
		Duel.SendtoGrave(g,REASON_COST)
	end
end
function c13130030.thcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c13130030.costfilter(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_TRAP) and c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function c13130030.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13130030.costfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c13130030.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c13130030.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c13130030.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end
function c13130030.togfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsAbleToGrave()
end
function c13130030.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsReason(REASON_EFFECT)
end
function c13130030.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13130030.togfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) and eg:IsExists(c13130030.repfilter,1,nil,tp) and Duel.GetMatchingGroupCount(c13130030.filter,tp,LOCATION_ONFIELD,0,nil)>0 end
	return Duel.SelectYesNo(tp,aux.Stringid(13130030,1))
end
function c13130030.repval(e,c)
	return c13130030.repfilter(c,e:GetHandlerPlayer())
end
function c13130030.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c13130030.togfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,POS_FACEUP,REASON_EFFECT)
end
function c13130030.effcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c13130030.filter,tp,LOCATION_ONFIELD,0,nil)>1
end
function c13130030.efilter3(e,te)
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c13130030.effcon3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c13130030.filter,tp,LOCATION_ONFIELD,0,nil)>2
end
function c13130030.efilter4(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c13130030.effcon4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c13130030.filter,tp,LOCATION_ONFIELD,0,nil)>3
end
function c13130030.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetMatchingGroupCount(c13130030.filter,tp,LOCATION_ONFIELD,0,nil)==5
end
function c13130030.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*3)
end