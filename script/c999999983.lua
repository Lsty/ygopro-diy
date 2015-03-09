--传说之枪兵 迪卢木多·奥迪那
function c999999983.initial_effect(c)
	--summon with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4022819,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c999999983.ntcon)
	c:RegisterEffect(e1)
    --search
	local e2=Effect.CreateEffect(c)	
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,999999983+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c999999983.tg)
	e2:SetOperation(c999999983.op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
    --pierce
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e4)
end
function c999999983.ntcon(e,c)
	if c==nil then return true end
	return c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
end
function c999999983.spfilter(c)
	return c:IsType(TYPE_EQUIPE) and c:IsDiscardable()
end
function c999999983.spcon(e,c)
	if c==nil then return true end
	local g=Duel.GetMatchingGroup(c999999983.spfilter,tp,LOCATION_HAND,0,nil)
	if not c:IsAbleToGraveAsCost() then
		g:RemoveCard(c)
	end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
	and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)<Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE,nil)
end
function c999999983.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c999999983.spfilter,c:GetControler(),LOCATION_HAND,0,nil)
	if not c:IsAbleToGraveAsCost() then
		g:RemoveCard(c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c999999983.filter(c)
	local code=c:GetCode()
	return (code==999999973 or code==999999974) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c999999983.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c999999983.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c999999983.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c999999983.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g1:GetCount()>0 then
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	end

end
