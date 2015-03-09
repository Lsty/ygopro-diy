--末际急军
function c9990805.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(9990805)
	e1:SetCountLimit(1,9990805+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9990805.target)
	e1:SetOperation(c9990805.activate)
	c:RegisterEffect(e1)
	if not c9990805.global_check then
		c9990805.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_LEAVE_FIELD)
		ge1:SetOperation(c9990805.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c9990805.checkop(e,tp,eg,ep,ev,re,r,rp)
	local ck=eg:FilterCount(Card.IsReason,nil,REASON_DESTROY)
	if ck>=2 then Duel.RaiseEvent(eg,9990805,e,r,rp,ep,ck) end
end
function c9990805.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c9990805.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c9990805.sumlimit)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,p)
end
function c9990805.sumlimit(e,c,sump,sumtype,sumpos,targetp,sumtp)
	return c:IsLocation(LOCATION_GRAVE)
end
