--DeathScythe
function c20121129.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c20121129.xyzfilter,8,2)
	c:EnableReviveLimit()
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c20121129.cost)
	e1:SetTarget(c20121129.target1)
	e1:SetOperation(c20121129.operation1)
	c:RegisterEffect(e1)
end
function c20121129.xyzfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function c20121129.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c20121129.filter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsCanTurnSet()
end
function c20121129.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c20121129.filter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c20121129.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c20121129.operation1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c20121129.filter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENCE)
	end
end