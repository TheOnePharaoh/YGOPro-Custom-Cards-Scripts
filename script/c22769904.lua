--Dreadnought Mark - 004 Smokescreen
function c22769904.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22769904,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(c22769904.sumcon)
	e1:SetTarget(c22769904.sumtg)
	e1:SetOperation(c22769904.sumop)
	c:RegisterEffect(e1)
	--cannot be effect target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--token
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22769904,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCondition(c22769904.tokcon)
	e3:SetTarget(c22769904.toktg)
	e3:SetOperation(c22769904.tokop)
	c:RegisterEffect(e3)
	--synchro level
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e4:SetTarget(c22769904.syntg)
	e4:SetValue(1)
	e4:SetOperation(c22769904.synop)
	c:RegisterEffect(e4)
end
function c22769904.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and ev>=2000
end
function c22769904.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,200,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22769904.sumop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),200,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
function c22769904.tokcon(e,tp,eg,ep,ev,re,r,rp)
	local st=e:GetHandler():GetSummonType()
	return st>=(SUMMON_TYPE_SPECIAL+200) and st<(SUMMON_TYPE_SPECIAL+250)
end
function c22769904.toktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,22769926,0,0xaa12,2000,2000,10,RACE_MACHINE,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c22769904.tokop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,22769926,0,0xaa12,2000,2000,10,RACE_MACHINE,ATTRIBUTE_WIND) then return end
	for i=1,2 do
		local token=Duel.CreateToken(tp,22769926)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
end
function c22769904.dreadnoughtsynlevel(c)
	return 4
end
function c22769904.synfilter(c,syncard,tuner,f)
	return c:IsFaceup() and c:IsNotTuner() and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c))
end
function c22769904.syntg(e,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()-c:GetLevel()
	local lv4=syncard:GetLevel()-c22769904.dreadnoughtsynlevel(c)
	if lv<=0 and lv4<=0 then return false end
	local g=Duel.GetMatchingGroup(c22769904.synfilter,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	local res=g:CheckWithSumEqual(Card.GetSynchroLevel,lv,minc,maxc,syncard)
	local res2=g:CheckWithSumEqual(c22769904.dreadnoughtsynlevel,lv4,minc,maxc)
	return res or res2
end
function c22769904.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()-c:GetLevel()
	local lv4=syncard:GetLevel()-c22769904.dreadnoughtsynlevel(c)
	local g=Duel.GetMatchingGroup(c22769904.synfilter,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	local res=g:CheckWithSumEqual(Card.GetSynchroLevel,lv,minc,maxc,syncard)
	local res2=g:CheckWithSumEqual(c22769904.dreadnoughtsynlevel,lv4,minc,maxc)
	local sg=nil
	if (res2 and res and Duel.SelectYesNo(tp,aux.Stringid(22769904,2)))
		or (res2 and not res) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		sg=g:SelectWithSumEqual(tp,c22769904.dreadnoughtsynlevel,lv4,minc,maxc)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		sg=g:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv,minc,maxc,syncard)
	end
	Duel.SetSynchroMaterial(sg)
end