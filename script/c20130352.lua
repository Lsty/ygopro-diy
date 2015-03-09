--第七深渊 涅古蕾莉亚·涅比洛丝
function c20130352.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FIEND),5,2)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c20130352.sumlimit1)
	e1:SetCondition(c20130352.dscon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c20130352.cost)
	e2:SetTarget(c20130352.sptg)
	e2:SetOperation(c20130352.spop)
	c:RegisterEffect(e2)
end
function c20130352.sumlimit1(e,c)
	return (c:IsRace(RACE_FIEND) or c:IsRace(RACE_SPELLCASTER)) and c:IsAttribute(ATTRIBUTE_LIGHT) and not c:IsType(TYPE_TOKEN)
end
function c20130352.dscon(e)
	return e:GetHandler():GetOverlayCount()~=0
end
function c20130352.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c20130352.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,20130326,0,0x4011,0,0,2,RACE_FIEND,ATTRIBUTE_LIGHT) end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ft,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ft,0,0)
end
function c20130352.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,20130326,0,0x4011,0,0,2,RACE_FIEND,ATTRIBUTE_LIGHT) then return end
	local g=Group.CreateGroup()
	for i=1,ft do
		local token=Duel.CreateToken(tp,20130326)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(c20130352.sumlimit)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		token:RegisterEffect(e1,true)
		g:AddCard(token)
	end
	Duel.SpecialSummonComplete()
end
function c20130352.sumlimit(e,c)
	return not c:IsRace(RACE_FIEND)
end