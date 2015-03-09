--神天龙-卷龙
function c9991202.initial_effect(c)
	--Special Summon From Hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9991202,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP_DEFENCE,0)
	e1:SetValue(0x40000fff)
	e1:SetCondition(c9991202.spcon)
	e1:SetOperation(c9991202.spop)
	c:RegisterEffect(e1)
	--Special Summon From Deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9991202,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9991202)
	e2:SetTarget(c9991202.tg1)
	e2:SetOperation(c9991202.op1)
	c:RegisterEffect(e2)
	--Fuck Spell & Trap
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9991202,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCountLimit(1,9991202)
	e3:SetCondition(c9991202.con2)
	e3:SetTarget(c9991202.tg2)
	e3:SetOperation(c9991202.op2)
	c:RegisterEffect(e3)
	--Xyz Limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e4:SetCondition(c9991202.xlcon)
	e4:SetValue(aux.TRUE)
	c:RegisterEffect(e4)
end
function c9991202.spfilter(c)
	return c:IsRace(RACE_WYRM) and c:IsAbleToGraveAsCost()
end
function c9991202.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9991202.spfilter,tp,LOCATION_HAND,0,1,c)
end
function c9991202.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9991202.spfilter,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST)
end
function c9991202.filter(c,e,tp)
	return c:IsSetCard(0xfff) and c:IsAbleToGrave()
end
function c9991202.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9991202.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c9991202.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9991202.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then Duel.SendtoGrave(g,REASON_EFFECT)end
end
function c9991202.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c9991202.con2(e,tp,eg,ep,ev,re,r,rp)
	return ( not e:GetHandler():IsLocation(LOCATION_DECK) ) and r==REASON_FUSION and e:GetHandler():GetReasonCard():IsSetCard(0xfff)
end
function c9991202.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GetMatchingGroup(c9991202.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return sg:GetCount()~=0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c9991202.op2(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c9991202.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
function c9991202.xlcon(e,c)
	return e:GetHandler():IsDefencePos()
end
