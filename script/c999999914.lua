--チューナー·キャプチャー
function c999999914.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c999999914.condition)
	e1:SetOperation(c999999914.operation)
	c:RegisterEffect(e1)
end
function c999999914.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:GetSummonType()==SUMMON_TYPE_SYNCHRO and ep==tp and tc:IsCode(44508094)
	    and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5
end
function c999999914.filter(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c999999914.xcfilter(c,e,tp)
	return c:IsCode(44508094) and c:IsFaceup()
end
function c999999914.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	local ct=g:FilterCount(Card.IsType,nil,TYPE_TUNER)
	if ct==0 then return end
	if ct==1 or ct==2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	    local g=Duel.SelectMatchingCard(tp,c999999914.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	    if g:GetCount()>0 then
		    Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end	
	elseif ct==3 or ct==4 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	    local g=Duel.SelectMatchingCard(tp,c999999914.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	    if g:GetCount()>0 then
		    Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
		local sg=Duel.GetMatchingGroup(c999999914.xcfilter,tp,LOCATION_MZONE,0,nil)
	    local c=e:GetHandler()
	    local tc=sg:GetFirst()
	    while tc do
		    local e1=Effect.CreateEffect(c)
		    e1:SetType(EFFECT_TYPE_SINGLE)
		    e1:SetCode(EFFECT_UPDATE_ATTACK)
		    e1:SetReset(RESET_EVENT+0x1fe0000)
		    e1:SetValue(1500)
		    tc:RegisterEffect(e1)
		    tc=sg:GetNext()
	    end
	elseif ct==5 then
	    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	    local g=Duel.SelectMatchingCard(tp,c999999914.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	    if g:GetCount()>0 then
		    Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
		local sg=Duel.GetMatchingGroup(c999999914.xcfilter,tp,LOCATION_MZONE,0,nil)
	    local c=e:GetHandler()
	    local tc=sg:GetFirst()
	    while tc do
		    local e1=Effect.CreateEffect(c)
		    e1:SetType(EFFECT_TYPE_SINGLE)
		    e1:SetCode(EFFECT_UPDATE_ATTACK)
		    e1:SetReset(RESET_EVENT+0x1fe0000)
		    e1:SetValue(1500)
		    tc:RegisterEffect(e1)
		    tc=sg:GetNext()
	    end
	    local tg=Duel.GetFirstMatchingCard(c999999914.lxfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	    if tg then
		    Duel.SpecialSummon(tg,0,tp,tp,false,true,POS_FACEUP)
	    end
    end	
end
function c999999914.lxfilter(c,e,tp)
	return c:GetCode()==24696097 and c:IsCanBeSpecialSummoned(e,0,tp,false,true)
end
