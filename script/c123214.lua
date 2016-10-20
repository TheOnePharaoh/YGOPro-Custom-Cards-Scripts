--Arcana Force EX The Ruler of Balance
function c123214.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c123214.spcon)
	e1:SetOperation(c123214.spop)
	c:RegisterEffect(e1)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	--coin
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(123214,0))
	e4:SetCategory(CATEGORY_COIN)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetTarget(c123214.cointg)
	e4:SetOperation(c123214.coinop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e6)
	--immune
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_IMMUNE_EFFECT)
	e7:SetValue(1)
	c:RegisterEffect(e7)
end
function c123214.spfilter(c,code)
	return c:GetOriginalCode()==code
end
function c123214.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.CheckReleaseGroup(tp,c123214.spfilter,1,nil,69831560)
		and Duel.CheckReleaseGroup(tp,c123214.spfilter,1,nil,5861892)
end
function c123214.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectReleaseGroup(tp,c123214.spfilter,1,1,nil,69831560)
	local g2=Duel.SelectReleaseGroup(tp,c123214.spfilter,1,1,nil,5861892)
	g1:Merge(g2)
	Duel.Release(g1,REASON_COST)
end
function c123214.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c123214.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local res=0
	if c:IsHasEffect(73206827) then
		res=1-Duel.SelectOption(tp,60,61)
	else res=Duel.TossCoin(tp,1) end
	c123214.arcanareg(c,res)
end
function c123214.arcanareg(c,coin)
	--coin effect	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCountLimit(1)
	e1:SetCondition(c123214.con)
	e1:SetOperation(c123214.op)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCondition(c123214.con2)
	e2:SetOperation(c123214.op2)
	e2:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e2)	
	c:RegisterFlagEffect(36690018,RESET_EVENT+0x1ff0000,EFFECT_FLAG_CLIENT_HINT,1,coin,63-coin)
end	
function c123214.con(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and e:GetHandler():GetFlagEffectLabel(36690018)==1
end
function c123214.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if not tc then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CARDTYPE)
	local res=Duel.SelectOption(1-tp,70,71,72)
	Duel.ConfirmDecktop(tp,1)
	if (res==0 and tc:IsType(TYPE_MONSTER))
		or (res==1 and tc:IsType(TYPE_SPELL))
		or (res==2 and tc:IsType(TYPE_TRAP)) then
		local WIN_REASON_ARCANA = 0x54
		Duel.Win(1-tp,WIN_REASON_ARCANA)
	else
		local WIN_REASON_ARCANA = 0x54
		Duel.Win(tp,WIN_REASON_ARCANA)
	end
	Duel.ShuffleDeck(tp)
end
function c123214.con2(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and e:GetHandler():GetFlagEffectLabel(36690018)==0
end
function c123214.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(1-tp,1)
	local tc=g:GetFirst()
	if not tc then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local res=Duel.SelectOption(tp,70,71,72)
	Duel.ConfirmDecktop(1-tp,1)
	if (res==0 and tc:IsType(TYPE_MONSTER))
		or (res==1 and tc:IsType(TYPE_SPELL))
		or (res==2 and tc:IsType(TYPE_TRAP)) then
		local WIN_REASON_ARCANA = 0x54
		Duel.Win(tp,WIN_REASON_ARCANA)
	else
		local WIN_REASON_ARCANA = 0x54
		Duel.Win(1-tp,WIN_REASON_ARCANA)
	end
	Duel.ShuffleDeck(1-tp)
end
