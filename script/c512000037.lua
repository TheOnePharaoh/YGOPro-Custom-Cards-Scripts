--光の創造神 ホルアクティ
function c512000037.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode3(c,10000010,10000000,10000020,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c512000037.splimit)
	c:RegisterEffect(e1)
	--win
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c512000037.winop)
	c:RegisterEffect(e2)
end
function c512000037.splimit(e,se,sp,st)
	return se:GetHandler():IsCode(39913299)
end
function c512000037.winop(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local rc=re:GetHandler()
	if rc:IsCode(39913299) then
		local WIN_REASON_CREATORGOD = 0x13
		Duel.Win(tp,WIN_REASON_CREATORGOD)
	end
end
