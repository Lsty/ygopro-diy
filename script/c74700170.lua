--义妹·艾杰莉
function c74700170.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,74700170+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c74700170.target)
	e1:SetOperation(c74700170.activate)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c74700170.splimit)
	c:RegisterEffect(e2)
end
function c74700170.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsType(TYPE_NORMAL) and not c:IsSetCard(0x747) and c:IsLocation(LOCATION_HAND+LOCATION_DECK)
end
function c74700170.tgfilter(c)
	return c:IsType(TYPE_NORMAL) and c:IsAbleToGrave()
end
function c74700170.filter(c,lv)
	return c:GetLevel()==lv
end
function c74700170.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c74700170.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c74700170.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c74700170.tgfilter,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=g:Select(tp,1,1,nil)
	g:Remove(c74700170.filter,nil,g1:GetFirst():GetLevel())
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(74700170,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g2=g:Select(tp,1,1,nil)
		g:Remove(c74700170.filter,nil,g2:GetFirst():GetLevel())
		g1:Merge(g2)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(74700170,1)) then
			g2=g:Select(tp,1,1,nil)
			g1:Merge(g2)
		end
	end
	if g1:GetCount()>0 then
		Duel.SendtoGrave(g1,REASON_EFFECT)
	end
end