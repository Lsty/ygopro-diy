--Makeup -惨剧-
function c54500018.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c54500018.cost)
	e1:SetTarget(c54500018.target)
	e1:SetOperation(c54500018.activate)
	c:RegisterEffect(e1)
end
function c54500018.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,54500018)==0 end
	Duel.RegisterFlagEffect(tp,54500018,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c54500018.gfilter(c)
	return c:IsFaceup() and (c:IsCode(54500000) or c:IsCode(54500010) or c:IsCode(54500011) or c:IsCode(54500012) or c:IsCode(54500013) or c:IsCode(54500014))
end
function c54500018.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c54500018.gfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		local ct=g:GetCount()
		e:SetLabel(ct)
		return ct>0 and Duel.IsPlayerCanDraw(tp,ct)
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,e:GetLabel())
end
function c54500018.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(c54500018.gfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local ct=g:GetCount()
	Duel.Draw(p,ct,REASON_EFFECT)
end