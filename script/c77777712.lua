--Witchcrafter Ukina
function c77777712.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c77777712.splimit)
	c:RegisterEffect(e2)
	--scale swap
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_PZONE)
	e3:SetDescription(aux.Stringid(77777712,0))
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCountLimit(1)
	e3:SetCondition(c77777712.sccon)
--	e3:SetTarget(c77777712.sctg)
	e3:SetOperation(c77777712.scop)
	c:RegisterEffect(e3)
	--Combine Levels
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetDescription(aux.Stringid(77777712,2))
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetTarget(c77777712.target)
	e4:SetOperation(c77777712.activate)
	c:RegisterEffect(e4)
--[[	--special summon rule
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_SPSUMMON_PROC)
	e5:SetRange(LOCATION_HAND)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e5:SetCountLimit(1,77777712)
	e5:SetCondition(c77777712.spcon)
	c:RegisterEffect(e5)]]--
	--effect gain
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_BE_MATERIAL)
	e6:SetCondition(c77777712.efcon)
	e6:SetOperation(c77777712.efop)
	c:RegisterEffect(e6)
	
end

function c77777712.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x407) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c77777712.sccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end

function c77777712.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local scl=c:GetLeftScale()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LSCALE)
	e1:SetValue(c:GetRightScale())
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_RSCALE)
	e2:SetValue(scl)
	c:RegisterEffect(e2)
end


function c77777712.filter1(c,tp)
	return c:IsLevelAbove(1) and c:IsSetCard(0x407)
end
function c77777712.filter2(c,rac)
	return c:IsLevelAbove(1) and c:IsSetCard(0x407)
end
function c77777712.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c77777712.filter1,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1=Duel.SelectTarget(tp,c77777712.filter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c77777712.filter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst(),g1:GetFirst():GetRace())
end
function c77777712.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	if tc1:IsRelateToEffect(e) and tc1:IsFaceup() and tc2:IsRelateToEffect(e) and tc2:IsFaceup() then
		local lv=tc1:GetLevel()+tc2:GetLevel()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL_FINAL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc1:RegisterEffect(e1)
		local e2=e1:Clone()
		tc2:RegisterEffect(e2)
	end
end

function c77777712.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)and c:IsSetCard(0x407)
end
function c77777712.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c77777712.cfilter,tp,LOCATION_MZONE,0,1,nil)
end


function c77777712.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function c77777712.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	--spsummon
	local e3=Effect.CreateEffect(rc)
	e3:SetDescription(aux.Stringid(77777712,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,7777771202)
	e3:SetTarget(c77777712.sptg)
	e3:SetOperation(c77777712.spop)
	rc:RegisterEffect(e3,true)
end

function c77777712.spfilter(c,e,tp)
	return c:IsSetCard(0x407) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77777712.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c77777712.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c77777712.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c77777712.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c77777712.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end