--M Black★Rock Shooter
function c20121130.initial_effect(c)
	c:SetStatus(STATUS_UNSUMMONABLE_CARD,true)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c20121130.spcon)
	e1:SetTarget(c20121130.target1)
	e1:SetOperation(c20121130.operation1)
	c:RegisterEffect(e1)
	--atk/def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(c20121130.value)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENCE)
	c:RegisterEffect(e5)
end
function c20121130.spfilter(c)
	return c:IsCode(20121108) or c:IsCode(20121145) or c:IsCode(20121110) or c:IsCode(20121132) or c:IsCode(20121133) or c:IsCode(20121130) or c:IsCode(20121150)
end
function c20121130.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c20121130.spfilter,tp,LOCATION_REMOVED,0,1,nil)
end
function c20121130.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c20121130.spfilter,tp,LOCATION_REMOVED,0,1,nil)
end
function c20121130.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectMatchingCard(tp,c20121130.spfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SendtoDeck(g1,nil,2,REASON_COST)
end
function c20121130.filter(c)
	return c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c20121130.value(e,c)
	return Duel.GetMatchingGroupCount(c20121130.filter,c:GetControler(),LOCATION_GRAVE,0,nil)*500
end