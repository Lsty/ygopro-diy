--血之梦魇 芙兰朵露·斯卡雷特
function c87700019.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c87700019.xyzfilter,4,2)
	c:EnableReviveLimit()
	--change effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c87700019.chcon)
	e1:SetCost(c87700019.cost)
	e1:SetTarget(c87700019.chtg)
	e1:SetOperation(c87700019.chop)
	c:RegisterEffect(e1)
	--indestructable by effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c87700019.xyzfilter(c)
	return c:IsSetCard(0x733) or c:IsSetCard(0x877) or c:GetCode()==73300034 or c:GetCode()==87700018
end
function c87700019.chcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:GetType()==TYPE_TRAP and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c87700019.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c87700019.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c87700019.filter,rp,0,LOCATION_ONFIELD,1,nil) end
end
function c87700019.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c87700019.repop)
end
function c87700019.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDestructable()
end
function c87700019.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c87700019.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		if Duel.Destroy(tc,REASON_EFFECT)~=0 and Duel.IsPlayerCanDraw(tp,1)
			and not (tc:IsSetCard(0x733) or tc:IsSetCard(0x877) or tc:GetCode()==73300034 or tc:GetCode()==87700018) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end