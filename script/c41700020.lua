--百万鬼夜行
function c41700020.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c41700020.cost)
	e1:SetTarget(c41700020.target)
	e1:SetOperation(c41700020.activate)
	c:RegisterEffect(e1)
	if not c41700020.global_check then
		c41700020.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c41700020.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c41700020.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function c41700020.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if not tc:IsRace(RACE_FIEND) then
			c41700020[tc:GetSummonPlayer()]=false
		end
		tc=eg:GetNext()
	end
end
function c41700020.clear(e,tp,eg,ep,ev,re,r,rp)
	c41700020[0]=true
	c41700020[1]=true
end
function c41700020.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c41700020[tp] end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c41700020.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c41700020.splimit(e,c)
	return not c:IsRace(RACE_FIEND)
end
function c41700020.spfilter(c,e,tp,lv)
	return c:IsRace(RACE_FIEND) and c:IsType(TYPE_NORMAL) and c:GetLevel()<=lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c41700020.filter(c,e,tp)
	return c:IsFaceup() and c:GetLevel()>0 and c:IsSetCard(0x417)
		and Duel.IsExistingMatchingCard(c41700020.spfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,c:GetLevel())
end
function c41700020.filter2(c,code)
	return c:GetCode()==code
end
function c41700020.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c41700020.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c41700020.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c41700020.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
end
function c41700020.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(c41700020.spfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp,tc:GetLevel())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=g:Select(tp,1,1,nil)
	local sg=tg:GetFirst()
	local dg=g:Filter(c41700020.filter2,nil,sg:GetCode())
	local sc=dg:GetFirst()
	while ft>0 and sc do
		Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP)
		ft=ft-1
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		sc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetOperation(c41700020.desop)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetCountLimit(1)
		sc:RegisterEffect(e2,true)
		sc=dg:GetNext()
	end
	Duel.SpecialSummonComplete()
end
function c41700020.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),nil,REASON_EFFECT)
end