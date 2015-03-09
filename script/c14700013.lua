--神葬「反转结界」
function c14700013.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(c14700013.condition)
	e1:SetTarget(c14700013.target)
	e1:SetOperation(c14700013.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c14700013.handcon)
	c:RegisterEffect(e2)
end
function c14700013.filter1(c)
	return not (c:IsSetCard(0x147) or (c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_AQUA)))
end
function c14700013.condition(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabelObject(Duel.GetAttacker())
	return ep==tp and Duel.GetAttacker():IsControler(1-tp) and not Duel.IsExistingMatchingCard(c14700013.filter1,tp,LOCATION_GRAVE,0,1,nil)
end
function c14700013.filter(c,e,tp,dam)
	return c:IsType(TYPE_XYZ) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_AQUA) and c:IsAttackBelow(dam) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c14700013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c14700013.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,ev) end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c14700013.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c14700013.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,ev)
	local tg=Duel.GetFirstTarget()
	if g:GetCount()~=0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
		if tg:IsRelateToEffect(e) and not tg:IsImmuneToEffect(e) then
			local sg=g:GetFirst()
			local og=tg:GetOverlayGroup()
			if og:GetCount()>0 then
				Duel.SendtoGrave(og,REASON_RULE)
			end
			Duel.Overlay(sg,Group.FromCards(tg))
		end
	end
end
function c14700013.handcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttackTarget()==nil
end