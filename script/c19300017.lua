--镜现诗·水中的技师
function c19300017.initial_effect(c)
	c:SetUniqueOnField(1,0,19300017)
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c19300017.thcost)
	e1:SetTarget(c19300017.tg)
	e1:SetOperation(c19300017.op)
	c:RegisterEffect(e1)
	if not c19300017.global_check then
		c19300017.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c19300017.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c19300017.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function c19300017.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if not tc:IsSetCard(0x193) then
			c19300017[tc:GetSummonPlayer()]=false
		end
		tc=eg:GetNext()
	end
end
function c19300017.clear(e,tp,eg,ep,ev,re,r,rp)
	c19300017[0]=true
	c19300017[1]=true
end
function c19300017.cffilter(c)
	return c:IsSetCard(0x193) and c:GetCode()~=19300017 and not c:IsPublic()
end
function c19300017.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c19300017[tp] and Duel.IsExistingMatchingCard(c19300017.cffilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c19300017.cffilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c19300017.splimit)
	e1:SetLabelObject(e)
	Duel.RegisterEffect(e1,tp)
end
function c19300017.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x193)
end
function c19300017.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local t={}
	local i=1
	local p=1
	local lv=e:GetHandler():GetLevel()
	for i=1,8 do 
		if lv~=i then t[p]=i p=p+1 end
	end
	t[p]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(19300017,0))
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
end
function c19300017.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end