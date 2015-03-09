--缭音之魔姬
function c66600015.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c66600015.xyzfilter,4,2)
	c:EnableReviveLimit()
	--DESTROY
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CHAIN_UNIQUE)
	e1:SetCode(EVENT_BECOME_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c66600015.cost)
	e1:SetCondition(c66600015.con)
	e1:SetTarget(c66600015.tg)
	e1:SetOperation(c66600015.op)
	c:RegisterEffect(e1)
	--pos
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CHAIN_UNIQUE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c66600015.ccost)
	e2:SetTarget(c66600015.target)
	e2:SetOperation(c66600015.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function c66600015.xyzfilter(c)
	return c:IsSetCard(0x666) or c:IsRace(RACE_FIEND)
end
function c66600015.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,66600015)==0 end
	Duel.RegisterFlagEffect(tp,66600015,RESET_PHASE+PHASE_END,0,1)
end
function c66600015.con(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(e:GetHandler())
end
function c66600015.thfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c66600015.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66600001.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c66600015.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0,nil)
end
function c66600015.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if tc:IsType(TYPE_MONSTER) then
			Duel.ChangePosition(tc,POS_FACEDOWN_DEFENCE)
		else
			Duel.ChangePosition(tc,POS_FACEDOWN)
			tc:SetStatus(STATUS_SET_TURN,false)
			Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		end
	end
end
function c66600015.ccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,166600015)==0 and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	Duel.RegisterFlagEffect(tp,166600015,RESET_PHASE+PHASE_END,0,1)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c66600015.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x666) and c:IsCanTurnSet() and c:IsType(TYPE_MONSTER)
end
function c66600015.setfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet() and c:IsType(TYPE_MONSTER)
end
function c66600015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c66600015.filter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c66600015.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c66600015.sfilter(c,e)
	return c:IsFaceup() and c:IsRelateToEffect(e)
end
function c66600015.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(c66600015.sfilter,nil,e)
	if tg:GetCount()>0 then
		Duel.ChangePosition(tg,POS_FACEDOWN_DEFENCE)
	end
end