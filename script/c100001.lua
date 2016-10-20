--Malicius Spirit A
function c100001.initial_effect(c)
	--lvup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100001,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c100001.lvtg)
	e1:SetCountLimit(1,100001)
	e1:SetOperation(c100001.lvop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--sme
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetTarget(c100001.syntg)
	e4:SetValue(1)
	e4:SetOperation(c100001.synop)
	c:RegisterEffect(e4) 
end
function c100001.lvfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE) and not c:IsType(TYPE_TUNER)
end
function c100001.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100001.lvfilter,tp,LOCATION_MZONE,0,1,nil) end
	local opt=Duel.SelectOption(tp,aux.Stringid(100001,1),aux.Stringid(100001,2))
	e:SetLabel(opt)
end
function c100001.lvop(e,tp,eg,ep,ev,re,r,rp)
	local opt=e:GetLabel()
	local g=Duel.GetMatchingGroup(c100001.lvfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		if opt==0 then
			e1:SetValue(-1)
		else
			e1:SetValue(1)
		end
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c100001.synfilter1(c,syncard,tuner,f)
	return c:IsFaceup() and c:IsNotTuner() and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c))
end
function c100001.synfilter2(c,syncard,tuner,f)
	return c:IsRace(RACE_ZOMBIE) and c:IsNotTuner() and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c))
end
function c100001.syntg(e,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()-c:GetLevel()
	if lv<=0 then return false end
	local g=Duel.GetMatchingGroup(c100001.synfilter1,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	if syncard:IsSetCard(0x700) then
		local exg=Duel.GetMatchingGroup(c100001.synfilter2,syncard:GetControler(),LOCATION_REMOVED,0,c,syncard,c,f)
		g:Merge(exg)
	end
	return g:CheckWithSumEqual(Card.GetSynchroLevel,lv,minc,maxc,syncard)
end
function c100001.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()-c:GetLevel()
	local g=Duel.GetMatchingGroup(c100001.synfilter1,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	if syncard:IsSetCard(0x700) then
		local exg=Duel.GetMatchingGroup(c100001.synfilter2,syncard:GetControler(),LOCATION_REMOVED,0,c,syncard,c,f)
		g:Merge(exg)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local sg=g:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv,minc,maxc,syncard)
	Duel.SetSynchroMaterial(sg)
end