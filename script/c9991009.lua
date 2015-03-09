--虚无极致 焰
function c9991009.initial_effect(c)
	--Synchro
	aux.AddSynchroProcedure2(c,nil,aux.FilterBoolFunction(Card.IsCode,9991006))
	c:EnableReviveLimit()
	--Destruction Immunity
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--Tachyon Spiral
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9991009,0))
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetHintTiming(0,0x1c0)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c9991009.tstg)
	e3:SetOperation(c9991009.tsop)
	c:RegisterEffect(e3)
	--Power Up
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9991009,1))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c9991009.ccost)
	e4:SetOperation(c9991009.cop)
	c:RegisterEffect(e4)
end
function c9991009.tstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	if Duel.GetTurnPlayer()==e:GetHandlerPlayer() then Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription()) end
end
function c9991009.tsop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	local tc=g:GetFirst()
	while tc do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			tc:RegisterEffect(e3)
		end
		tc=g:GetNext()
	end
end
function c9991009.cfilter(c)
	return c:IsSetCard(0x1eff) and c:IsType(TYPE_MONSTER) and not c:IsCode(9991006) and c:IsAbleToRemoveAsCost()
end
function c9991009.ccost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c9991009.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cg=Duel.SelectMatchingCard(tp,c9991009.cfilter,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
	e:SetLabel(cg:GetOriginalCode())
	Duel.Remove(cg,POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c9991009.cop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() local val=e:GetLabel()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(800)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
	c:CopyEffect(val,RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END,1)	  
end
