--狩人的分影 「时崎狂三」
function c127800.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c127800.spcon)
	c:RegisterEffect(e1)
	--distory
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c127800.atkcon)
	e2:SetTarget(c127800.destg)
	e2:SetOperation(c127800.desop)
	c:RegisterEffect(e2)
end
function c127800.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9fa)
end
function c127800.get_count(g)
	if g:GetCount()==0 then return 0 end
	local ret=0
	repeat
		local tc=g:GetFirst()
		g:RemoveCard(tc)
		local ct1=g:GetCount()
		g:Remove(Card.IsCode,nil,tc:GetCode())
		local ct2=g:GetCount()
		local c=ct1-ct2+1
		if c>ret then ret=c end
	until g:GetCount()==0 or g:GetCount()<=ret
	return ret
end
function c127800.spcon(e,c)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(c127800.cfilter,tp,LOCATION_MZONE,0,nil)
	local ct=c127800.get_count(g)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and ct==2 or ct==3
end
function c127800.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
		and c:IsPreviousLocation(LOCATION_OVERLAY) 
end
function c127800.filter(c)
	return  c:IsDestructable()
end
function c127800.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c127800.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c127800.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c127800.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c127800.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
