--Twisted Vocaloid Nephilise's Shadow - Code D.E.S.T.R.O.Y. 02
function c66652246.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c66652246.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c66652246.sprcon)
	e2:SetOperation(c66652246.sprop)
	c:RegisterEffect(e2)
	--ignite
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(66652246,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,66652246)
	e3:SetTarget(c66652246.changetg)
	e3:SetOperation(c66652246.changeop)
	c:RegisterEffect(e3)
	--cannot be material
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL+EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--multi attack
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(66652246,3))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCountLimit(1,66652246)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c66652246.mtcon)
	e5:SetOperation(c66652246.mtop)
	c:RegisterEffect(e5)
	--att change
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(66652246,4))
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetTarget(c66652246.atttg)
	e6:SetOperation(c66652246.attop)
	c:RegisterEffect(e6)
end
function c66652246.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c66652246.spfilter1(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x0dac403) and Duel.IsExistingMatchingCard(c66652246.spfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,c)
end
function c66652246.spfilter2(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK)
end
function c66652246.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c66652246.spfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp)
end
function c66652246.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(66652246,0))
	local g1=Duel.SelectMatchingCard(tp,c66652246.spfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(66652246,1))
	local g2=Duel.SelectMatchingCard(tp,c66652246.spfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,g1:GetFirst())
	g1:Merge(g2)
	local tc=g1:GetFirst()
	while tc do
		if not tc:IsFaceup() then Duel.ConfirmCards(1-tp,tc) end
		tc=g1:GetNext()
	end
	Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c66652246.changetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,563)
	local rc=Duel.AnnounceRace(tp,1,0xffffff)
	e:SetLabel(rc)
	e:GetHandler():SetHint(CHINT_RACE,rc)
end
function c66652246.changeop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetTarget(c66652246.tglimit)
	e1:SetLabel(e:GetLabel())
	e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	Duel.RegisterEffect(e1,tp)
end
function c66652246.tglimit(e,c)
	return c:IsRace(e:GetLabel())
end
function c66652246.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=1 and Duel.GetCurrentPhase()==PHASE_MAIN1
		and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_BP) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5
end
function c66652246.mtop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	local ct=g:FilterCount(Card.IsRace,nil,RACE_MACHINE)
	Duel.ShuffleDeck(tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
	e1:SetValue(ct-1)
	e:GetHandler():RegisterEffect(e1)
end
function c66652246.attfilter(c)
	return c:IsFaceup() and not c:IsAttribute(ATTRIBUTE_DARK)
end
function c66652246.atttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66652246.attfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c66652246.attop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c66652246.attfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=sg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(ATTRIBUTE_DARK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=sg:GetNext()
	end
end
